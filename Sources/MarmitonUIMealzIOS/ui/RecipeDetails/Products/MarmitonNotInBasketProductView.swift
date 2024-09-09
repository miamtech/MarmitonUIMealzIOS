//
//  MarmitonNotInBasketProductView.swift
//
//
//  Created by Diarmuid McGonagle on 03/07/2024.
//

import mealzcore
import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonNotInBasketProductView: NotInBasketProductProtocol {
    public init() {}
    public func content(params: NotInBasketProductParameters) -> some View {
        VStack {
            MealzRecipeDetailsIgnoredProductView.ingredientNameAndAmount(
                ingredientName: params.ingredientName,
                ingredientUnit: params.ingredientUnit,
                ingredientQuantity: params.ingredientQuantity,
                guestCount: params.guestsCount,
                defaultRecipeGuest: params.defaultRecipeGuest
            )
            MealzRecipeDetailsIgnoredProductView.willNotBeAddedText()
            if let cta = params.onAddToBasket {
                MarmitonRecipeDetailsIgnoredProductView.ignoreOrAddProduct(onChooseProduct: cta)
            }
        }
        .background(Color.mealzColor(.lightBackground))
        .cornerRadius(Dimension.sharedInstance.mCornerRadius)
        .padding(.horizontal, Dimension.sharedInstance.mPadding)
    }

    @ViewBuilder
    public static func ignoreOrAddProduct(onChooseProduct: @escaping () -> Void) -> some View {
        Button(action: onChooseProduct, label: {
            Text(Localization.ingredient.chooseProduct.localised).padding(Dimension.sharedInstance.mPadding)
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyMediumBoldStyle)
                .foregroundColor(Color.mealzColor(.primary))
        })
        .background(Color.mealzColor(.white))
        .cornerRadius(Dimension.sharedInstance.buttonCornerRadius)
        .padding(Dimension.sharedInstance.mPadding)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: Dimension.sharedInstance.mCornerRadius)
                .stroke(Color.mealzColor(.primary), lineWidth: 1)
        )
    }
}
