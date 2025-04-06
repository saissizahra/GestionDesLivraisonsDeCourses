<?php

// app/Models/ClientProfile.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClientProfile extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'email','address', 'phone', 'avatar_url'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}