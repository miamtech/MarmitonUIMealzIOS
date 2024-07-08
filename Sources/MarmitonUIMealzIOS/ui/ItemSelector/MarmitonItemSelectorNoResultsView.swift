//
//  MarmitonItemSelectorNoResultsView.swift
//
//
//  Created by Diarmuid McGonagle on 03/07/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonItemSelectorNoResultsView: ItemSelectorNoResultsProtocol {
    public init() {}
    public func content(params: ItemSelectorNoResultsParameters) -> some View {
        VStack {
            Spacer()
            Image.mealzIcon(icon: .search)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.mealzColor(.primary))
                .scaledToFit()
                .frame(height: 65)
            Text(params.title)
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.titleMediumStyle)
            if let subtitle = params.subtitle {
                Text(subtitle)
                    .foregroundColor(Color.mealzColor(.primaryText))
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.subtitleStyle)
            }
            Spacer()
        }.frame(maxHeight: .infinity)
    }
}
