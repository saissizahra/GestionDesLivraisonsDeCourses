<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class DriverController extends Controller {
    // Obtenir les infos d'un livreur
    public function show($id) {
        $driver = DriverProfile::with('user')->find($id);
        if (!$driver) {
            return response()->json(['message' => 'Livreur non trouvé'], 404);
        }
        return response()->json([
            'name' => $driver->user->name,
            'email' => $driver->user->email,
            'phone' => $driver->phone,
            'latitude' => $driver->latitude,
            'longitude' => $driver->longitude
        ]);
    }

    // Mettre à jour les infos d'un livreur
    public function update(Request $request, $id) {
        $driver = DriverProfile::find($id);
        if (!$driver) {
            return response()->json(['message' => 'Livreur non trouvé'], 404);
        }

        $driver->update($request->all());
        return response()->json(['message' => 'Informations mises à jour']);
    }
    public function index()
    {
        try {
            $drivers = User::with('driverProfile')
                ->where('role', 'driver')
                ->whereHas('driverProfile', function($query) {
                    $query->where('is_available', true);
                })
                ->get()
                ->map(function($user) {
                    return [
                        'id' => $user->id,
                        'name' => $user->name,
                        'phone' => $user->driverProfile->phone,
                        'is_available' => $user->driverProfile->is_available,
                        'position' => [
                            'latitude' => $user->driverProfile->latitude,
                            'longitude' => $user->driverProfile->longitude
                        ]
                    ];
                });

            return response()->json([
                'success' => true,
                'data' => $drivers
            ]);

        } catch (\Exception $e) {
            Log::error('Error fetching drivers: '.$e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve drivers'
            ], 500);
        }
    }


}