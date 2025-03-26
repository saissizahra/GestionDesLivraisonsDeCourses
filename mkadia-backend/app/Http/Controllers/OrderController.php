<?php
namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\User;
use App\Models\Promotion;
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
            // Valider les données
            $validatedData = $request->validate([
                'user_id' => 'required|exists:users,id',
                'items' => 'required|array',
                'items.*.product_id' => 'required|exists:products,id',
                'items.*.quantity' => 'required|integer|min:1',
                'items.*.price' => 'required|numeric|min:0',
                'tax' => 'required|numeric|min:0', // Ajouter la taxe
                'delivery_fee' => 'required|numeric|min:0', // Ajouter les frais de livraison
            ]);
    
            DB::beginTransaction();
    
            // Calculer le montant total des produits (subtotal)
            $subtotal = 0;
            foreach ($request->items as $item) {
                $subtotal += $item['price'] * $item['quantity'];
            }
    
            // Calculer le montant total (subtotal + tax + delivery_fee)
            $totalAmount = $subtotal + $request->tax + $request->delivery_fee;
    
            // Créer la commande
            $order = Order::create([
                'user_id' => $request->user_id,
                'total_amount' => $totalAmount, // Inclure tax et delivery_fee
                'order_date' => now(),
                'order_status' => 'pending',
            ]);
    
            // Créer les éléments de la commande
            foreach ($request->items as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'price' => $item['price'],
                    'quantity' => $item['quantity'],
                    'total' => $item['price'] * $item['quantity'],
                ]);
    
                // Mettre à jour le stock du produit
                $product = Product::find($item['product_id']);
                $product->quantity -= $item['quantity'];
                $product->save();
            }
    
            DB::commit();
    
            return response()->json([
                'success' => true,
                'message' => 'Commande créée avec succès',
                'order_id' => $order->id,
                'total_amount' => $totalAmount,
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

    public function updateStatus(Request $request, $id)
    {
        try {
            $order = Order::findOrFail($id);
            $order->order_status = $request->order_status;
            $order->save();

            return response()->json([
                'success' => true,
                'message' => 'Statut de la commande mis à jour',
                'order' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erreur lors de la mise à jour du statut',
                'error' => $e->getMessage(),
            ], 500);
        }
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
}