<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Delivery;

class DeliveryController extends Controller
{
    // Créer une livraison
    public function store(Request $request)
    {
        $request->validate([
            'order_id' => 'required|exists:orders,id',
            'driver_id' => 'nullable|exists:drivers,id',
            'delivery_status' => 'required|in:assigned,in_progress,delivered',
            'estimated_delivery_time' => 'nullable|date',
        ]);

        $delivery = Delivery::create($request->all());

        return response()->json($delivery, 201);
    }

    // Mettre à jour le statut d'une livraison
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'delivery_status' => 'required|in:assigned,in_progress,delivered',
        ]);

        $delivery = Delivery::findOrFail($id);
        $delivery->update(['delivery_status' => $request->delivery_status]);

        return response()->json($delivery, 200);
    }
}