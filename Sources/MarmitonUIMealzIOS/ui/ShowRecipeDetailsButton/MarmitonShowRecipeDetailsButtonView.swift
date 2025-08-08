//
//  MarmitonShowRecipeDetailsButtonView.swift
//
//
//  Created by Diarmuid McGonagle on 20/09/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonShowRecipeDetailsButtonView: ShowRecipeDetailsButtonSuccessProtocol {
    public init() {}
    public func content(params: ShowRecipeDetailsButtonSuccessParameters) -> some View {
        Button(action: params.onButtonAction, label: {
            HStack {
                Text(params.buttonText)
                    .foregroundColor(Color.mealzColor(.white))
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.subtitleStyle)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.75)
                Image.mealzIcon(icon: .basket)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(Color.mealzColor(.white))
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: .infinity)
            .padding(Dimension.sharedInstance.mPadding)
            .background(Color.mealzColor(params.isRecipeInBasket ? .darkGray : .primary))
            .cornerRadius(Dimension.sharedInstance.buttonCornerRadius)
            .frame(height: 30)
        })
    }
}