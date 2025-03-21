<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('product_reviews', function (Blueprint $table) {
            $table->id(); // Clé primaire auto-incrémentée
            $table->foreignId('review_id')->constrained()->onDelete('cascade'); // Clé étrangère vers la table `reviews`
            $table->foreignId('product_id')->constrained()->onDelete('cascade'); // Clé étrangère vers la table `products`
            $table->tinyInteger('rating')->unsigned(); // Note de 1 à 5 pour le produit
            $table->timestamps(); // Colonnes `created_at` et `updated_at`
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_reviews');
    }
};
