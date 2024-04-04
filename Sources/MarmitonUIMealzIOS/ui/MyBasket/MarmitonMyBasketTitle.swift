//
//  MarmitonMyBasketTitle.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealzIOSFramework
import MealzUIModuleIOS

@available(iOS 14, *)
public struct MarmitonMyBasketTitle: BaseTitleProtocol {
    let changeStore: () -> Void
    public init(changeStore: @escaping () -> Void) {
        self.changeStore = changeStore
    }
    public func content(params: TitleParameters) -> some View {
        VStack {
            MarmitonChangeStoreButton(changeStore: changeStore)
            MealzMyMealsTitle().content(params: params)
        }
    }
}
