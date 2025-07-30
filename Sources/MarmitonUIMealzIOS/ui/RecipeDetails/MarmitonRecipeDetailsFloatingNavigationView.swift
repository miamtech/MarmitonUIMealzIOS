//
//  MarmitonRecipeDetailsFloatingNavigationView.swift
//
//
//  Created by didi on 22/10/2024.
//

import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonRecipeDetailsFloatingNavigationView: RecipeDetailsFloatingNavigationProtocol {
    public init() {}

    public func content(
        params: RecipeDetailsFloatingNavigationParameters
    ) -> some View {
        HStack {
            MealzRecipeDetailsFloatingNavigationView.closePage(onRecipeDetailsClosed: params.onRecipeDetailsClosed)
                .padding(Dimension.sharedInstance.mPadding)
            Spacer()
            if let title = params.title {
                Text(title)
                    .lineLimit(2)
                    .truncationMode(Text.TruncationMode.tail)
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.titleStyle)
                    .foregroundColor(Color.mealzColor(.standardDarkText))
            }
            Spacer()
            MealzRecipeDetailsFloatingNavigationView.likeButton(recipeId: params.recipeId, isEnabled: params.isLikeEnabled, analyticsPath: params.analyticsPath)
        }.background(Color.mealzColor(.white))
    }
}
