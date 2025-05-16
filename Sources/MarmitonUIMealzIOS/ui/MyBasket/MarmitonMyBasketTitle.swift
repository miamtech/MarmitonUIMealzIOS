//
//  MarmitonMyBasketTitle.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import SwiftUI
import MealziOSSDK

@available(iOS 14, *)
public struct MarmitonMyBasketTitle: BaseTitleProtocol {
    let viewOptions: StoreLocatorSectionViewOptions?
    let changeStore: () -> Void
    
    public init(
        viewOptions: StoreLocatorSectionViewOptions? = nil,
        changeStore: @escaping () -> Void
    ) {
        self.viewOptions = viewOptions
        self.changeStore = changeStore
    }
    public func content(params: TitleParameters) -> some View {
        VStack {
            StoreLocatorSection(params: StoreLocatorSectionParameters(
                viewOptions: viewOptions ?? StoreLocatorSectionViewOptions(),
                actions: StoreLocatorButtonActions(changeStore: changeStore)
            ))
            MealzMyMealsTitle().content(params: params)
        }
    }
}
