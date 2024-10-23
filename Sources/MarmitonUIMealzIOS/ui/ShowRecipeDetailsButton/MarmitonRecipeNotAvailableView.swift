//
//  MarmitonRecipeNotAvailableView.swift
//
//
//  Created by Diarmuid McGonagle on 20/09/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonRecipeNotAvailableView: EmptyProtocol {
    public init() {}
    public func content(params: BaseEmptyParameters) -> some View {
        HStack {
            // TODO: Use your icon & text
            Text("Recipe products cannot be added to basket")
                .foregroundColor(Color.mealzColor(.standardDarkText))
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
        }
    }
}
