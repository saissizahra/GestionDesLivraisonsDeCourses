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
        Schema::create('deliveries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained()->onDelete('cascade');  
            $table->foreignId('driver_id')->nullable()->constrained('drivers')->onDelete('set null');
            $table->dateTime('estimated_delivery_time')->nullable()->after('delivery_status');
            $table->enum('delivery_status', ['assigned', 'in_progress', 'delivered'])->default('assigned'); // Garder le statut
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('deliveries');
    }
};
