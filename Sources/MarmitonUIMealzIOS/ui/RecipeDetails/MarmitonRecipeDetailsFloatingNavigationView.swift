//
//  MarmitonRecipeDetailsFloatingNavigationView.swift
//
//
//  Created by didi on 22/10/2024.
//

import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonRecipeDetailsFloatingNavigationView: RecipeDetailsFloatingNavigationProtocol {
    public var isEmpty: Bool {
        return true
    }

    public init() {}
    public func content(params: RecipeDetailsFloatingNavigationParameters) -> some View {
        EmptyView()
    }
}
