<?php
namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\User;
use App\Models\Promotion;
use App\Models\DriverProfil;

use App\Models\Delivery;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'user_id' => 'required|exists:users,id',
                'items' => 'required|array',
                'items.*.product_id' => 'required|exists:products,id',
                'items.*.quantity' => 'required|integer|min:1',
                'items.*.price' => 'required|numeric|min:0',
                'delivery_address' => 'required|string|max:255',
                'tax' => 'required|numeric|min:0',
                'delivery_fee' => 'required|numeric|min:0',
            ]);
    
            DB::beginTransaction();
    
            $subtotal = 0;
            foreach ($request->items as $item) {
                $subtotal += $item['price'] * $item['quantity'];
            }
    
            $totalAmount = $subtotal + $request->tax + $request->delivery_fee;
    
            $order = Order::create([
                'user_id' => $request->user_id,
                'total_amount' => $totalAmount,
                'order_date' => now(),
                'delivery_address' => $request->delivery_address, // <-- Champ manquant !
                'order_status' => 'confirmed',
            ]);
    
            foreach ($request->items as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'price' => $item['price'],
                    'quantity' => $item['quantity'],
                    'total' => $item['price'] * $item['quantity'],
                ]);
    
                $product = Product::find($item['product_id']);
                $product->quantity -= $item['quantity'];
                $product->save();
            }
    
            DB::commit();
    
            return response()->json([
                'success' => true,
                'message' => 'Commande créée avec succès',
                'order' => $order,
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Erreur lors de la création de la commande: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la création de la commande',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function index()
    {
        $orders = Order::with(['user', 'items.product'])->get();
        return response()->json($orders);
    }

    public function show($id)
    {
        $order = Order::with(['user', 'items.product'])->findOrFail($id);
        return response()->json($order);
    }

    public function getUserOrders($userId)
    {
        $orders = Order::with(['items.product.category'])
            ->where('user_id', $userId)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'total_amount' => $order->total_amount,
                    'order_date' => $order->order_date,
                    'order_status' => $order->order_status,
                    'delivery_address' => $order->delivery_address,
                    'items' => $order->items->map(function ($item) {
                        return [
                            'product_id' => $item->product_id,
                            'quantity' => $item->quantity,
                            'price' => $item->price,
                            'product' => [
                                'name' => $item->product->name,
                                'image_url' => $item->product->image_url,
                                'category' => $item->product->category,
                            ],
                        ];
                    }),
                ];
            });
    
        return response()->json(['orders' => $orders]);
    }
    public function confirmOrder(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => 'required|exists:orders,id',
            'promo_code' => 'nullable|string',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Données invalides',
                'errors' => $validator->errors()
            ], 422);
        }
    
        // Trouver la commande
        $order = Order::find($request->order_id);
        if (!$order) {
            return response()->json([
                'status' => false,
                'message' => 'Commande non trouvée',
            ], 404);
        }
    
        // Appliquer le code promo si fourni
        if ($request->promo_code) {
            $promotion = Promotion::where('code', $request->promo_code)->first();
    
            if ($promotion) {
                // Incrémenter le compteur d'utilisation
                $promotion->usage_count += 1;
                $promotion->save();
    
                // Appliquer la réduction (exemple)
                $order->total_amount -= $promotion->discount_amount;
                $order->save();
            }
        }
    
        // Mettre à jour le statut de la commande
        $order->order_status = 'confirmed'; // Assurez-vous que cette valeur est valide
        $order->save();
    
        return response()->json([
            'status' => true,
            'message' => 'Commande confirmée avec succès',
            'order' => $order,
        ]);
    }
        // Assigner un livreur à une commande

    public function assignDriver(Request $request, $orderId)
    {
        $request->validate([
            'driver_id' => 'required|exists:users,id'
        ]);

        $order = Order::findOrFail($orderId);
        $order->update([
            'driver_id' => $request->driver_id,
            'order_status' => 'assigned'
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Livreur assigné avec succès',
            'order' => $order->load(['user', 'driver', 'items.product'])
        ]);
    }
    
    

    // Mettre à jour le statut de la commande
    public function updateStatus(Request $request, $orderId)
    {
        try {
            $order = Order::findOrFail($orderId);
            
            $request->validate([
                'status' => 'required|in:in_progress,delivered'
            ]);
            
            $order->update(['order_status' => $request->status]);
            
            return response()->json([
                'success' => true,
                'message' => 'Statut mis à jour avec succès',
                'order' => $order
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la mise à jour du statut',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Récupérer les commandes pour l'admin
    public function getAdminOrders()
    {
        $orders = Order::with(['user', 'driver', 'items.product'])
            ->whereIn('order_status', ['confirmed', 'assigned', 'in_progress'])
            ->get();
            
        return response()->json($orders);
    }

    // Récupérer les commandes pour un livreur
    public function getDriverOrders($driverId)
    {
        $orders = Order::with(['user:id,name', 'items.product:id,name,image_url'])
            ->where('driver_id', $driverId)
            ->whereIn('order_status', ['assigned', 'in_progress', 'delivered'])
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'status' => $order->order_status ?? 'inconnu',
                    'total_amount' => $order->total_amount ?? 0,
                    'delivery_address' => $order->delivery_address ?? 'Adresse inconnue',
                    'created_at' => $order->created_at->format('Y-m-d H:i'),
                    'phone' => $order->user->clientProfile->phone ?? 'Non spécifié',
                    'items' => $order->items->map(function ($item) {
                        return [
                            'product_name' => $item->product->name ?? 'Produit inconnu',
                            'product_image' => $item->product->image_url ?? '',
                            'quantity' => $item->quantity ?? 0,
                            'price' => $item->price ?? 0,
                            'total' => $item->total ?? 0
                        ];
                    })->toArray()
                ];
            });
            
        return response()->json($orders);
    }

    public function confirmDelivery($orderId)
    {
        try {
            $order = Order::findOrFail($orderId);
    
            // Validation supplémentaire
            if ($order->order_status !== 'delivered') {
                return response()->json([
                    'success' => false,
                    'message' => 'La commande doit être en statut "delivered" avant confirmation'
                ], 400);
            }
    
            DB::beginTransaction();
    
            $order->update(['order_status' => 'completed']);
            
            // Ici vous pouvez ajouter d'autres logiques métier
            // Ex: notifier le client, enregistrer des statistiques, etc.
    
            DB::commit();
    
            return response()->json([
                'success' => true,
                'message' => 'Livraison confirmée avec succès',
                'order' => $order->load(['user', 'items.product'])
            ]);
    
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Erreur confirmation livraison: " . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la confirmation',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}