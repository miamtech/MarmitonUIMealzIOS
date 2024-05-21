//
//  MarmitonRecipeDetailsHeaderView.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonRecipeDetailsHeaderView: RecipeDetailsHeaderProtocol {
    let changeStore: () -> Void
    public init(changeStore: @escaping () -> Void) {
        self.changeStore = changeStore
    }
    public func content(params: RecipeDetailsHeaderParameters) -> some View {
        VStack {
            MarmitonChangeStoreButton(changeStore: changeStore)
            MarmitonCounter(
                currentAmount: params.currentGuests,
                backgroundColor: Color.clear,
                buttonStrokeColor: Color.mealzColor(.border),
                content: {
                    HStack {
                        Spacer()
                        Text("\(params.currentGuests)")
                            .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyBoldStyle)
                            .frame(minWidth: 10, alignment: .center)
                            .foregroundColor(Color.mealzColor(.primary))
                        Image.mealzIcon(icon: .cutlery)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.mealzColor(.primary))
                            .frame(width: 15, height: 15)
                        Spacer()
                    }
                }, buttonAction: params.onUpdateGuests)
            .padding([.top, .horizontal], Dimension.sharedInstance.mlPadding)
        }
    }
}
