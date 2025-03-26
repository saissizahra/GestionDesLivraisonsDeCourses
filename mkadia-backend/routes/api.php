<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\PromotionController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\DeliveryController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route protégée par Sanctum (exemple d'authentification)
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/products/search', [ProductController::class, 'search']);

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

// Routes pour les promotions
Route::get('/promotions', [PromotionController::class, 'index']);
Route::post('/promotions/verify', [PromotionController::class, 'verifyCode']);
Route::post('/promotions/apply', [PromotionController::class, 'applyCode']);

// Routes pour les évaluations
Route::post('reviews', [ReviewController::class, 'store']);
Route::get('reviews/{id}', [ReviewController::class, 'show']);
Route::get('products/{productId}/reviews', [ReviewController::class, 'getProductReviews']);
Route::get('users/{userId}/reviews', [ReviewController::class, 'getUserReviews']);

Route::post('/deliveries', [DeliveryController::class, 'store']);
Route::put('/deliveries/{id}/status', [DeliveryController::class, 'updateStatus']);