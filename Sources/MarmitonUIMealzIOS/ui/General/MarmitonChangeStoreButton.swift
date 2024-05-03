//
//  MarmitonChangeStoreButton.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealziOSSDK
import MealzUIiOSSDK

@available(iOS 14, *)
public struct MarmitonChangeStoreButton: View {
    let changeStore: () -> Void
    init(changeStore: @escaping () -> Void) {
        self.changeStore = changeStore
    }
    public var body: some View {
        StoreLocatorButton(params: StoreLocatorButtonParameters(
            actions: StoreLocatorButtonActions(changeStore: changeStore)))
    }
}
