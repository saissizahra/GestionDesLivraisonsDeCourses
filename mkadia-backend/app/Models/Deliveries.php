<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Delivery extends Model
{
    use HasFactory;

    /**
     * Les attributs qui sont mass assignable.
     *
     * @var array<string>
     */
    protected $fillable = [
        'order_id',
        'driver_id',
        'delivery_status',
    ];

    /**
     * Relation avec la table `orders`.
     * Une livraison appartient à une commande.
     */
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    /**
     * Relation avec la table `drivers`.
     * Une livraison est associée à un conducteur.
     */
    public function driver()
    {
        return $this->belongsTo(Driver::class);
    }
}