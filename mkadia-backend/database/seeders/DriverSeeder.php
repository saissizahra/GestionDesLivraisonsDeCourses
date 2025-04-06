<?php
// database/seeders/DriverSeeder.php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\DriverProfile;
use App\Models\User;

class DriverSeeder extends Seeder
{
    public function run()
    {
        $drivers = [
            [
                'name' => 'John Driver',
                'email' => 'driver1@example.com',
                'phone' => '0612345678',
                'latitude' => 48.8566,
                'longitude' => 2.3522,
                'is_available' => true
            ],
            [
                'name' => 'Jane Driver',
                'email' => 'driver2@example.com',
                'phone' => '0698765432',
                'latitude' => 48.8534,
                'longitude' => 2.3488,
                'is_available' => false
            ]
        ];

        foreach ($drivers as $driverData) {
            $user = User::create([
                'name' => $driverData['name'],
                'email' => $driverData['email'],
                'password' => bcrypt('password'),
                'role' => 'driver',
            ]);

            DriverProfile::create([
                'user_id' => $user->id,
                'phone' => $driverData['phone'],
                'latitude' => $driverData['latitude'],
                'longitude' => $driverData['longitude'],
                'is_available' => $driverData['is_available']
            ]);
        }
    }
}