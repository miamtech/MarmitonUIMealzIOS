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
        MealzMyBasketSwapper().content(params: params)
    }
}
