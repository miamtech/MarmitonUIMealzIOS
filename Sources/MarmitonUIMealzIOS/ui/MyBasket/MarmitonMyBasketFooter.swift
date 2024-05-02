//
//  File.swift
//  
//
//  Created by Damien Walerowicz on 02/05/2024.
//

import SwiftUI
import MealzIOSFramework
import MealzUIModuleIOS

@available(iOS 14, *)
public struct MarmitonMyBasketFooter: MyBasketFooterProtocol {
    
    let onSubmitOrder: (String) -> Void
    public init(onSubmitOrder: @escaping (String) -> Void) {
        self.onSubmitOrder = onSubmitOrder
    }
    public func content(params: MyBasketFooterParameters) -> some View {
        MealzMyBasketFooter().content(params:params)
    }
}
