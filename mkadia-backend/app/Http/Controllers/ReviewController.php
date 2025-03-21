<?php

namespace App\Http\Controllers;

use App\Models\Review;
use App\Models\ProductReview;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReviewController extends Controller
{
    /**
     * Soumettre une nouvelle évaluation
     */
    public function store(Request $request)
    {
        // Valider les données d'entrée
        $validator = Validator::make($request->all(), [
            'order_id' => 'required|exists:orders,id',
            'user_id' => 'required|exists:users,id',
            'service_rating' => 'required|integer|min:1|max:5',
            'delivery_rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
            'product_reviews' => 'required|array',
            'product_reviews.*.product_id' => 'required|exists:products,id',
            'product_reviews.*.rating' => 'required|integer|min:1|max:5',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Créer l'évaluation générale
            $review = Review::create([
                'order_id' => $request->order_id,
                'user_id' => $request->user_id,
                'service_rating' => $request->service_rating,
                'delivery_rating' => $request->delivery_rating,
                'comment' => $request->comment,
            ]);

            // Créer les évaluations de produits
            foreach ($request->product_reviews as $productReview) {
                if ($productReview['rating'] > 0) {
                    ProductReview::create([
                        'review_id' => $review->id,
                        'product_id' => $productReview['product_id'],
                        'rating' => $productReview['rating'],
                    ]);
                }
            }

            // Mettre à jour les notes moyennes des produits
            $this->updateProductRatings();

            return response()->json([
                'status' => true,
                'message' => 'Review submitted successfully',
                'review' => $review->load('productReviews')
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to submit review',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Récupérer les évaluations d'un produit
     */
    public function getProductReviews($productId)
    {
        try {
            $productReviews = ProductReview::where('product_id', $productId)
                ->with('review')
                ->get();

            return response()->json([
                'status' => true,
                'reviews' => $productReviews
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to get product reviews',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Récupérer les évaluations d'un utilisateur
     */
    public function getUserReviews($userId)
    {
        try {
            $reviews = Review::where('user_id', $userId)
                ->with('productReviews')
                ->get();

            return response()->json([
                'status' => true,
                'reviews' => $reviews
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to get user reviews',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Récupérer une évaluation spécifique
     */
    public function show($id)
    {
        try {
            $review = Review::with('productReviews')->findOrFail($id);

            return response()->json([
                'status' => true,
                'review' => $review
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to get review',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mettre à jour les notes moyennes des produits
     */
    private function updateProductRatings()
    {
        try {
            // Cette méthode peut être personnalisée selon votre logique
            // Par exemple, vous pourriez exécuter une requête SQL qui met à jour
            // la note moyenne de chaque produit en fonction des évaluations
            
            // Exemple simple (à adapter à votre structure de base de données)
            \DB::statement("
                UPDATE products p
                SET rate = (
                    SELECT AVG(pr.rating)
                    FROM product_reviews pr
                    WHERE pr.product_id = p.id
                )
                WHERE EXISTS (
                    SELECT 1
                    FROM product_reviews pr
                    WHERE pr.product_id = p.id
                )
            ");
        } catch (\Exception $e) {
            \Log::error('Failed to update product ratings: ' . $e->getMessage());
        }
    }
}