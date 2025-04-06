<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\ClientProfile;

class UserController extends Controller
{
    public function getUser(Request $request)
    {
        $user = $request->user();
        $clientProfile = ClientProfile::where('user_id', $user->id)->first();
        $orders = Order::with(['items.product', 'driver'])
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'total_amount' => $order->total_amount,
                    'status' => $order->order_status,
                    'date' => $order->created_at->format('Y-m-d H:i'),
                    'items' => $order->items->map(function ($item) {
                        return [
                            'product_name' => $item->product->name,
                            'quantity' => $item->quantity,
                            'price' => $item->price
                        ];
                    }),
                    'driver' => $order->driver ? [
                        'name' => $order->driver->name,
                        'phone' => $order->driver->driverProfile->phone ?? null
                    ] : null
                ];
            });
                    $orders = Order::with(['user:id,name', 'items.product:id,name,image_url'])
            ->where('driver_id', $driverId)
            ->whereIn('order_status', ['assigned', 'in_progress', 'delivered'])
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($order) {
                return [
                    'id' => $order->id,
                    'status' => $order->order_status,
                    'total_amount' => $order->total_amount,
                    'delivery_address' => $order->delivery_address,
                    'created_at' => $order->created_at->format('Y-m-d H:i'),
                    'user_name' => $order->user->name,
                    'items' => $order->items->map(function ($item) {
                        return [
                            'product_name' => $item->product->name,
                            'product_image' => $item->product->image_url,
                            'quantity' => $item->quantity,
                            'price' => $item->price,
                            'total' => $item->total
                        ];
                    })
                ];
            });

        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'address' => $clientProfile->address,
            'phone' => $clientProfile->phone,
            'avatarURL' => $clientProfile->avatar_url,
            'orders' => $orders 
        ]);
    }

    public function getAvailableDrivers()
    {
        $drivers = DriverProfile::with('user')
            ->available()
            ->get()
            ->map(function ($driver) {
                return [
                    'id' => $driver->user_id,
                    'name' => $driver->user->name,
                    'phone' => $driver->phone,
                    'latitude' => $driver->latitude,
                    'longitude' => $driver->longitude
                ];
            });

        return response()->json($drivers);
    }
}