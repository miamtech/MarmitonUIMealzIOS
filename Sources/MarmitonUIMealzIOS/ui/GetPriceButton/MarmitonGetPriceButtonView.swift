//
//  MarmitonGetPriceButtonEmptyView.swift
//
//
//  Created by Diarmuid McGonagle on 20/09/2024.
//
import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonGetPriceButtonView: EmptyProtocol {
    public init() {}
    public func content(params: BaseEmptyParameters) -> some View {
        VStack {
            if let cta = params.onOptionalCallback {
                Button(action: cta, label: {
                    HStack {
                        Image.mealzIcon(icon: .pan)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.mealzColor(.standardDarkText))
                        Text(Localization.price.seePrice.localised)
                            .foregroundColor(Color.mealzColor(.primary))
                            .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
                    }
                })
            }
        }
    }
}
