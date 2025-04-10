<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\PromotionController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\DeliveryController;


use App\Http\Controllers\DriverController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\UserController;

Route::middleware('auth:sanctum')->get('/user', [UserController::class, 'getUser']);

Route::get('/livreur/{id}', [DriverController::class, 'show']);
Route::put('/livreur/{id}', [DriverController::class, 'update']);

Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

// Route protégée par Sanctum (exemple d'authentification)
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::middleware(['auth:sanctum', 'driver'])->group(function () {
    Route::put('/driver/availability', [AuthController::class, 'updateDriverAvailability']);
    
    Route::get('/driver/status', function (Request $request) {
        return response()->json([
            'is_available' => $request->user()->driverProfile->is_available
        ]);
    });
});

Route::get('/admin/orders', [OrderController::class, 'getAdminOrders']);
Route::post('/orders/{id}/assign-driver', [OrderController::class, 'assignDriver']);

Route::get('/drivers/{driverId}/orders', [OrderController::class, 'getDriverOrders']);

Route::put('/orders/{id}/status', [OrderController::class, 'updateStatus']);
Route::get('/products/search', [ProductController::class, 'search']);

// Routes pour les drivers
Route::get('/drivers', [DriverController::class, 'index']); // Liste des drivers
Route::get('/drivers/{driverId}', [DriverController::class, 'show']); // Détail d'un driver
Route::post('/drivers', [DriverController::class, 'store']); // Création d'un driver (si nécessaire)
Route::put('/drivers/{driverId}', [DriverController::class, 'update']); // Mise à jour
Route::delete('/drivers/{driverId}', [DriverController::class, 'destroy']); // Suppression

// Routes pour les produits 
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);

// Routes pour les catégories
Route::get('/categories', [CategoryController::class, 'index']);

// Routes pour les commandes
Route::get('/orders', [OrderController::class, 'index']); // Toutes les commandes (admin)
Route::post('/orders', [OrderController::class, 'store']); 
Route::get('/orders/{id}', [OrderController::class, 'show']); // Détails d'une commande
Route::put('/orders/{id}/status', [OrderController::class, 'updateStatus']); // Mise à jour statut
Route::get('/users/{userId}/orders', [OrderController::class, 'getUserOrders']); // Commandes d'un user
Route::post('/orders/confirm', [OrderController::class, 'confirmOrder']);
// Ajoutez cette route
Route::put('/orders/{order}/confirm-delivery', [OrderController::class, 'confirmDelivery']);
// Routes pour les promotions
Route::get('/promotions', [PromotionController::class, 'index']);
Route::post('/promotions/verify', [PromotionController::class, 'verifyCode']);
Route::post('/promotions/apply', [PromotionController::class, 'applyCode']);

// Routes pour les évaluations
Route::post('reviews', [ReviewController::class, 'store']);
Route::get('    reviews/{id}', [ReviewController::class, 'show']);
Route::get('products/{productId}/reviews', [ReviewController::class, 'getProductReviews']);
Route::get('users/{userId}/reviews', [ReviewController::class, 'getUserReviews']);

