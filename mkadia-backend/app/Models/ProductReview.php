<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductReview extends Model
{
    protected $fillable = [
        'review_id',
        'product_id',
        'rating',
    ];

    public function review()
    {
        return $this->belongsTo(Review::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}