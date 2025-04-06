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
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('driver_id')->nullable()->constrained('users')->onDelete('set null');
            $table->decimal('total_amount', 8, 2);
            $table->dateTime('order_date');
            $table->string('delivery_address');
            $table->enum('order_status', ['pending', 'confirmed', 'assigned', 'in_progress', 'delivered', 'completed'])
                  ->default('pending');
            $table->dateTime('estimated_delivery_time')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
