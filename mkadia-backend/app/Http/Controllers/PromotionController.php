<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Promotion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PromotionController extends Controller
{
    /**
     * Récupérer toutes les promotions actives
     */
    public function index()
    {
        $promotions = Promotion::where('is_active', true)
            ->where('start_date', '<=', now())
            ->where('end_date', '>=', now())
            ->get();

        return response()->json($promotions);
    }

    /**
     * Vérifier la validité d'un code promotionnel
     */
    public function verifyCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'code' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Code promotionnel invalide',
                'errors' => $validator->errors()
            ], 422);
        }

        $promotion = Promotion::where('code', $request->code)
            ->where('is_active', true)
            ->where('start_date', '<=', now())
            ->where('end_date', '>=', now())
            ->first();

        if (!$promotion) {
            return response()->json([
                'status' => false,
                'message' => 'Code promotionnel invalide ou expiré'
            ], 404);
        }

        if ($promotion->usage_limit > 0 && $promotion->usage_count >= $promotion->usage_limit) {
            return response()->json([
                'status' => false,
                'message' => 'Ce code promotionnel a atteint sa limite d\'utilisation'
            ], 400);
        }

        return response()->json([
            'status' => true,
            'message' => 'Code promotionnel valide',
            'promotion' => $promotion
        ]);
    }

    /**
     * Appliquer un code promotionnel à une commande
     */
    public function applyCode(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'code' => 'required|string',
            'cart_total' => 'required|numeric|min:0',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Données invalides',
                'errors' => $validator->errors()
            ], 422);
        }
    
        $promotion = Promotion::where('code', $request->code)
            ->where('is_active', true)
            ->where('start_date', '<=', now())
            ->where('end_date', '>=', now())
            ->first();
    
        if (!$promotion) {
            return response()->json([
                'status' => false,
                'message' => 'Code promotionnel invalide ou expiré'
            ], 404);
        }
    
        if ($promotion->usage_limit > 0 && $promotion->usage_count >= $promotion->usage_limit) {
            return response()->json([
                'status' => false,
                'message' => 'Ce code promotionnel a atteint sa limite d\'utilisation'
            ], 400);
        }
    
        if ($request->cart_total < $promotion->min_purchase_amount) {
            return response()->json([
                'status' => false,
                'message' => 'Le montant minimum d\'achat n\'est pas atteint pour ce code',
                'min_purchase_amount' => $promotion->min_purchase_amount
            ], 400);
        }
    
        // Calculer la remise
        $discount = 0;
        $deliveryFee = 10; // Frais de livraison par défaut
    
        switch ($promotion->type) {
            case 'percentage':
                $discount = ($request->cart_total * $promotion->value) / 100;
                break;
            case 'fixed_amount':
                $discount = $promotion->value;
                break;
            case 'free_shipping':
                $discount = 0; // Pas de réduction sur le total, mais les frais de livraison sont gratuits
                $deliveryFee = 0; // Frais de livraison gratuits
                break;
        }
    
        // Incrémenter le compteur d'utilisation
        $promotion->usage_count += 1;
        $promotion->save();
    
        return response()->json([
            'status' => true,
            'message' => 'Code promotionnel appliqué avec succès',
            'promotion' => $promotion,
            'discount' => (float) $discount,
            'delivery_fee' => (float) $deliveryFee, // Retourner les frais de livraison mis à jour
            'final_total' => (float) max(0, $request->cart_total - $discount + $deliveryFee), // Inclure les frais de livraison
        ]);
    }

    public function confirmOrder(Request $request)
{
    $validator = Validator::make($request->all(), [
        'order_id' => 'required|exists:orders,id',
        'promo_code' => 'nullable|string',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'status' => false,
            'message' => 'Données invalides',
            'errors' => $validator->errors()
        ], 422);
    }

    // Trouver la promotion si un code promo est fourni
    if ($request->promo_code) {
        $promotion = Promotion::where('code', $request->promo_code)->first();

        if ($promotion) {
            // Incrémenter le compteur d'utilisation
            $promotion->usage_count += 1;
            $promotion->save();
        }
    }

    return response()->json([
        'status' => true,
        'message' => 'Commande confirmée avec succès',
    ]);
}
}