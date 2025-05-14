//
//  MarmitonMyBasketTitle.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonMyBasketTitle: MyBasketTitleProtocol {
    let changeStore: () -> Void
    public init(changeStore: @escaping () -> Void) {
        self.changeStore = changeStore
    }
    public func content(params: MyBasketTitleParameters) -> some View {
        VStack {
            MarmitonChangeStoreButton(changeStore: changeStore)
            MealzMyBasketTitle().content(params: params)
        }
    }
}
