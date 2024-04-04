//
//  MarmitonMyMealsEmpty.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealzIOSFramework

@available(iOS 14, *)
public struct MarmitonMyMealsEmpty: EmptyProtocol {
    public init() {}
    public func content(params: BaseEmptyParameters) -> some View {
        VStack(spacing: Dimension.sharedInstance.lPadding) {
            Spacer()
            Image.mealzIcon(icon: .search)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(height: 65)
                .foregroundColor(Color.mealzColor(.primary))
            Text(Localization.myMeals.noMealIdeaInBasket.localised)
                .foregroundColor(Color.mealzColor(.primaryText))
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.titleMediumStyle)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(Dimension.sharedInstance.lPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
