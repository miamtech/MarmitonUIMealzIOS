//
//  MarmitonChangeStoreButton.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealzIOSFramework

@available(iOS 14, *)
public struct MarmitonChangeStoreButton: View {
    let changeStore: () -> Void
    init(changeStore: @escaping () -> Void) {
        self.changeStore = changeStore
    }
    public var body: some View {
        Button(action: changeStore, label: {
            HStack {
                Text("My current Store")
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.subtitleStyle)
                    .foregroundColor(Color.mealzColor(.primary))
                Spacer()
                HStack {
                    Image.mealzIcon(icon: .swap)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color.mealzColor(.primary))
                    Text("Changer")
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
                        .foregroundColor(Color.mealzColor(.primary))
                }
                .padding(.vertical, Dimension.sharedInstance.mPadding)
                .padding(.horizontal, Dimension.sharedInstance.mlPadding)
                .background(
                    Capsule().foregroundColor(Color.mealzColor(.white)))
                .padding(.vertical, Dimension.sharedInstance.mPadding)
            }
        })
        .padding(.horizontal, Dimension.sharedInstance.lPadding)
        .frame(maxWidth: .infinity)
        .background(Color.mealzColor(.primaryBackground))
    }
}
