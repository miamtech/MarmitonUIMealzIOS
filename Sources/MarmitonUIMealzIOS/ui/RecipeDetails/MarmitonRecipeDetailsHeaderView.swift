//
//  MarmitonRecipeDetailsHeaderView.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonRecipeDetailsHeaderView: RecipeDetailsHeaderProtocol {

    public init() {}

    public func content(params: RecipeDetailsHeaderParameters) -> some View {
        VStack {
            // Navigation Header
            Spacer().frame(height: 65) // Don't put something under floating header of recipes details

            // Store Locator Button
            MealzStoreLocatorButton().content(params: StoreLocatorButtonParameters(
                selectedStore: params.selectedStore,
                buttonPressed: false,
                onButtonAction: {
                    params.onChangeStore?()
                }
            ))

            // Guests counter
            MarmitonCounter(
                currentAmount: params.currentGuests,
                backgroundColor: Color.clear,
                buttonStrokeColor: Color.mealzColor(.border),
                content: {
                    HStack {
                        Spacer()
                        Text("\(params.currentGuests)")
                            .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyBoldStyle)
                            .frame(minWidth: 10, alignment: .center)
                            .foregroundColor(Color.mealzColor(.primary))
                        Image.mealzIcon(icon: .cutlery)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.mealzColor(.primary))
                            .frame(width: 15, height: 15)
                        Spacer()
                    }
                }, buttonAction: params.onUpdateGuests)
            .padding(Dimension.sharedInstance.mlPadding)
        }
    }
}
