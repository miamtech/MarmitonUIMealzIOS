//
//  MarmitonMyBasketSwapper.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealzIOSFramework
import MealzUIModuleIOS

@available(iOS 14, *)
public struct MarmitonMyBasketSwapper: MyBasketSwapperProtocol {
    let onAddAnotherProduct: () -> Void
    public init(onAddAnotherProduct: @escaping () -> Void) {
        self.onAddAnotherProduct = onAddAnotherProduct
    }
    public func content(params: MyBasketSwapperParameters) -> some View {
        VStack {
            MealzMyBasketSwapper().content(params: params)
            VStack {
                Text("besoin de qqc?")
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
                    .foregroundColor(Color.mealzColor(.primaryText))
                Button {
                    onAddAnotherProduct()
                } label: {
                    Text("Add a project")
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
                        .foregroundColor(Color.mealzColor(.primary))
                }
                .padding(.horizontal, Dimension.sharedInstance.mPadding)
                .padding(.vertical, Dimension.sharedInstance.sPadding)
                .overlay(
                    Capsule().stroke(Color.mealzColor(.primary), lineWidth: 1.0))
                .padding(Dimension.sharedInstance.mPadding)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Dimension.sharedInstance.mCornerRadius )
                    .foregroundColor(Color.mealzColor(.lightBackground)))
            .padding()
        }
    }
}
