<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'driver_id',
        'total_amount',
        'order_date',
        'delivery_address',
        'order_status',
        'estimated_delivery_time',
    ];

    protected $dates = [
        'order_date',
        'created_at',
        'updated_at',
        'estimated_delivery_time',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function driver()
    {
        return $this->belongsTo(User::class, 'driver_id');
    }

    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
}