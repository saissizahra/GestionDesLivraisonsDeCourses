<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {
            $table->id(); // Clé primaire auto-incrémentée
            $table->foreignId('order_id')->constrained()->onDelete('cascade'); // Clé étrangère vers la table `orders`
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Clé étrangère vers la table `users`
            $table->tinyInteger('service_rating')->unsigned();
            $table->tinyInteger('delivery_rating')->unsigned(); // Note de 1 à 5 pour le service de livraison
            $table->text('comment')->nullable(); // Commentaire global
            $table->timestamps(); // Colonnes `created_at` et `updated_at`
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};
