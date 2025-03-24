<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Driver;

class DriverSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Driver::create([
            'name' => 'John Doe',
            'phone' => '0612345678',
            'latitude' => 34.0522,
            'longitude' => -118.2437,
        ]);

        Driver::create([
            'name' => 'Jane Smith',
            'phone' => '0698765432',
            'latitude' => 36.1699,
            'longitude' => -115.1398,
        ]);
    }
}