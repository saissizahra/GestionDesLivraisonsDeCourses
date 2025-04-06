<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DriverProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'phone',
        'latitude',
        'longitude',
        'is_available'
    ];

    protected $casts = [
        'is_available' => 'boolean',
        'latitude' => 'float',
        'longitude' => 'float'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'driver_id');
    }

    public function scopeAvailable($query)
    {
        return $query->where('is_available', true);
    }
}