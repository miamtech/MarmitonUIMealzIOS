//
//  MarmitonCounter.swift
//
//
//  Created by Diarmuid McGonagle on 05/04/2024.
//

import SwiftUI
import MealziOSSDK

@available (iOS 14, *)
public struct MarmitonCounter<Content: View>: View {
    let currentAmount: Int
    let backgroundColor: Color
    let buttonStrokeColor: Color
    let cornerRadius: CGFloat
    let content: () -> Content
    let buttonAction: (Int) -> Void
    
    public init(
        currentAmount: Int,
        backgroundColor: Color = Color.clear,
         buttonStrokeColor: Color = Color.clear,
         cornerRadius: CGFloat = Dimension.sharedInstance.mCornerRadius,
         content: @escaping () -> Content,
         buttonAction: @escaping (Int) -> Void
    ) {
        self.currentAmount = currentAmount
        self.backgroundColor = backgroundColor
        self.buttonStrokeColor = buttonStrokeColor
        self.cornerRadius = cornerRadius
        self.content = content
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Button {
                buttonAction(max((currentAmount - 1), 1))
            } label: {
                Image.mealzIcon(icon: .minus)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.mealzColor(.primaryText))
                    .frame(width: 20, height: 20)
            }
            .padding(Dimension.sharedInstance.mlPadding)
            Divider().frame(maxHeight: .infinity)
            content()
            Divider().frame(maxHeight: .infinity)
            Button {
                buttonAction(currentAmount + 1)
            } label: {
                Image.mealzIcon(icon: .plus)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.mealzColor(.primaryText))
                    .frame(width: 20, height: 20)
            }
            .padding(Dimension.sharedInstance.mlPadding)
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(buttonStrokeColor, lineWidth: 1.0)
        )
    }
}
