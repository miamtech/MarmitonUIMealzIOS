//
//  MarmitonRecipeDetailsIgnoredProductView.swift
//
//
//  Created by Diarmuid McGonagle on 03/07/2024.
//

import SwiftUI
import MealziOSSDK
import mealzcore

@available(iOS 14, *)
public struct MarmitonRecipeDetailsIgnoredProductView: RecipeDetailsIgnoredProductProtocol {
    
    public init() {}
    public func content(params: RecipeDetailsIgnoredProductParameters) -> some View {
        VStack {
            MealzRecipeDetailsIgnoredProductView.ingredientNameAndAmount(
                ingredientName: params.ingredientName,
                ingredientUnit: params.ingredientUnit,
                ingredientQuantity: params.ingredientQuantity,
                guestCount: params.guestsCount,
                defaultRecipeGuest: params.defaultRecipeGuest)
            MealzRecipeDetailsIgnoredProductView.willNotBeAddedText()
            MarmitonRecipeDetailsIgnoredProductView.ignoreOrAddProduct(onChooseProduct: params.onChooseProduct)
        }
        .background(Color.mealzColor(.lightBackground))
        .cornerRadius(Dimension.sharedInstance.mCornerRadius)
        .padding(.horizontal, Dimension.sharedInstance.mPadding)
    }
    
    @ViewBuilder
    public static func ignoreOrAddProduct(onChooseProduct: @escaping () -> Void) -> some View {
        Button(action: onChooseProduct, label: {
            Text(Localization.ingredient.chooseProduct.localised)
                .padding(Dimension.sharedInstance.mPadding)
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyMediumBoldStyle)
                .foregroundColor(Color.mealzColor(.primary))
        })
        .background(Color.mealzColor(.white))
        .cornerRadius(Dimension.sharedInstance.buttonCornerRadius)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: Dimension.sharedInstance.buttonCornerRadius)
                .stroke(Color.mealzColor(.primary), lineWidth: 1)
        )
        .padding(Dimension.sharedInstance.mPadding)
    }
}
