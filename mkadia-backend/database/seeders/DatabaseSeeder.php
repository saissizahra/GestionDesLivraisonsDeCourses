<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run()
    {
        // Appeler uniquement le seeder pour les utilisateurs
        $this->call([
            UsersTableSeeder::class,
            CategorySeeder::class,
            ProductSeeder::class,
            PromotionsSeeder::class,
            DriverSeeder::class

        ]);
    }
}
