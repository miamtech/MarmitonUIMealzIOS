//
//  MarmitonRecipeDetailsFooterView.swift
//
//
//  Created by miam x didi on 25/04/2024.
//

import mealzcore
import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonRecipeDetailsFooterView: RecipeDetailsFooterProtocol {
    let openMyBasket: () -> Void
    public init(openMyBasket: @escaping () -> Void) {
        self.openMyBasket = openMyBasket
    }
    
    public func content(params: RecipeDetailsFooterParameters) -> some View {
        var lockButton: Bool {
            return params.priceStatus == ComponentUiState.locked
                || params.priceStatus == ComponentUiState.loading
                || params.isAddingAllIngredients
        }
        return HStack(spacing: 0) {
            if lockButton {
                ProgressLoader(color: .primary, size: 24)
            } else {
                if params.totalPriceOfProductsAdded > 0 {
                    PriceInMyBasket(totalPriceInBasket: params.totalPriceOfProductsAdded.currencyFormatted)
                }
            }
            Spacer()
            if params.isAddingAllIngredients || lockButton {
                LoadingButton()
            } else {
                switch params.ingredientsStatus.type {
                case .noMoreToAdd:
                    if params.totalPriceOfProductsAdded > 0 {
                        OpenMyMealsCTA(
                            callToAction: {
                                // only launch event when all products have been added
                                params.callToAction()
                                openMyBasket()
                            },
                            buttonText: NSLocalizedString("mealz_see_my_basket", bundle: MarmitonUIMealzIOSBundle.bundle, comment: "Open My Meals button"),
                            disableButton: lockButton)
                    } else {
                        ContinueMyShoppingCTA(
                            callToAction: params.callToAction,
                            buttonText: Localization.recipeDetails.continueShopping.localised,
                            disableButton: lockButton)
                    }
                default:
                    MealzAddAllToBasketCTA(
                        callToAction: params.callToAction,
                        buttonText: String(format: String.localizedStringWithFormat(
                            Localization.ingredient.addProduct(numberOfProducts: params.ingredientsStatus.count).localised,
                            params.ingredientsStatus.count),
                        params.ingredientsStatus.count).appending(" (\(params.totalPriceOfRemainingProducts.currencyFormatted))"),
                        disableButton: lockButton)
                }
            }
        }
        .padding(Dimension.sharedInstance.lPadding)
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(Color.white)
    }
    
    struct LoadingButton: View {
        var body: some View {
            Button(action: {}, label: {
                ProgressLoader(color: .white, size: 24)
            })
            .padding(Dimension.sharedInstance.mlPadding)
            .background(Color.mealzColor(.primary))
            .cornerRadius(Dimension.sharedInstance.buttonCornerRadius)
        }
    }
    
    struct OpenMyMealsCTA: View {
        let callToAction: () -> Void
        let buttonText: String
        let disableButton: Bool
        
        var body: some View {
            Button(action: callToAction, label: {
                HStack {
                    Text(buttonText)
                        .foregroundColor(Color.mealzColor(.standardLightText))
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.subtitleStyle)
                    Image.mealzIcon(icon: .basket)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.mealzColor(.white))
                        .frame(width: 20, height: 20)
                }
            })
            .padding(Dimension.sharedInstance.mlPadding)
            .background(
                RoundedRectangle(cornerRadius: Dimension.sharedInstance.buttonCornerRadius)
                    .fill(Color.mealzColor(.primary))
            )
            .disabled(disableButton)
            .darkenView(disableButton)
        }
    }
    
    struct ContinueMyShoppingCTA: View {
        let callToAction: () -> Void
        let buttonText: String
        let disableButton: Bool
        
        var body: some View {
            Button(action: callToAction, label: {
                Text(buttonText)
                    .foregroundColor(Color.mealzColor(.primary))
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.subtitleStyle)
            })
            .padding(Dimension.sharedInstance.mlPadding)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: Dimension.sharedInstance.buttonCornerRadius)
                    .stroke(Color.mealzColor(.primary), lineWidth: 1))
            .disabled(disableButton)
            .darkenView(disableButton)
        }
    }
}
