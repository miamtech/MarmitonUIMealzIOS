//
//  MarmitonPriceNotAvailableView.swift
//
//
//  Created by Diarmuid McGonagle on 20/09/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonPriceNotAvailableView: EmptyProtocol {
    public init() {}
    public func content(params: BaseEmptyParameters) -> some View {
        HStack {
            Image.mealzIcon(icon: .pan)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color.mealzColor(.standardDarkText))
            // TODO: Use your icon & text
            Text("Price Not available")
                .foregroundColor(Color.mealzColor(.standardDarkText))
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
        }
    }
}
