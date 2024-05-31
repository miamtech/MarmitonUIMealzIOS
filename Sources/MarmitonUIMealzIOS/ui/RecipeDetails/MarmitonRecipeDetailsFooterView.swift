//
//  MarmitonRecipeDetailsFooterView.swift
//
//
//  Created by miam x didi on 25/04/2024.
//

import SwiftUI
import MealziOSSDK
import mealzcore
import MealzUIiOSSDK

@available(iOS 14, *)
public struct MarmitonRecipeDetailsFooterView: RecipeDetailsFooterProtocol {
    public init() {}
    public func content(params: RecipeDetailsFooterParameters) -> some View {
        // we will use the same UI View from Mealz Default, but overwrite the
        // CTA so that it sends our analytics
        MealzRecipeDetailsFooterView().content(params: RecipeDetailsFooterParameters(
            totalPriceOfProductsAdded: params.totalPriceOfProductsAdded,
            totalPriceOfProductsAddedPerGuest: params.totalPriceOfProductsAddedPerGuest,
            totalPriceOfRemainingProducts: params.totalPriceOfRemainingProducts,
            recipeStickerPrice: params.recipeStickerPrice,
            numberOfGuests: params.numberOfGuests,
            priceStatus: params.priceStatus,
            ingredientsStatus: params.ingredientsStatus,
            isAddingAllIngredients: params.isAddingAllIngredients,
            cookOnlyMode: params.cookOnlyMode,
            currentSelectedTab: params.currentSelectedTab,
            callToAction: {
                // only launch event when all products have been added or ignored
                if params.ingredientsStatus.type == IngredientStatusTypes.noMoreToAdd {
                    MealzDI.shared.analyticsService.sendEvent(
                        eventType: AnalyticsCompanion.shared.EVENT_BASKET_PREVIEW,
                        path: "",
                        props: AnalyticsCompanion.setProps())
                }
                params.callToAction()
            })
        )
    }
}
