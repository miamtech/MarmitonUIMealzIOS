//
//  MarmitonGetPriceButtonSuccessView.swift
//
//
//  Created by Diarmuid McGonagle on 20/09/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonGetPriceSuccessView: GetPriceButtonSuccessProtocol {
    public init() {}
    public func content(
        price: Double,
        guests: Int,
        currency: String
    ) -> some View {
        HStack {
            Image.mealzIcon(icon: .pan)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color.mealzColor(.standardDarkText))
            Text(price.pricePerPersonWithText(numberOfGuests: guests))
                .foregroundColor(Color.mealzColor(.standardDarkText))
                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
        }
    }
}
