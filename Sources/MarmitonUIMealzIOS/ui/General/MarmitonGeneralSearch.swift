//
//  MarmitonGeneralSearch.swift
//
//
//  Created by Diarmuid McGonagle on 03/07/2024.
//

import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonGeneralSearch: SearchProtocol {
    public init() {}
    public func content(params: SearchParameters) -> some View {
        var longerThanThreeChars: Bool {
            return params.searchText.wrappedValue.count > 2
        }
        return VStack(spacing: 10.0) {
            HStack(spacing: 10.0) {
                HStack(spacing: 10.0) {
                    TextField(Localization.catalog.searchTitle.localised, text: params.searchText, onCommit: {
                        params.onApply()
                    })

                    .frame(height: 45.0)
                    .disableAutocorrection(true)
                    Button {
                        params.onApply()
                    } label: {
                        Image.mealzIcon(icon: .search)
                            .renderingMode(.template)
                            .foregroundColor(Color.mealzColor(.white))
                            .padding(10)
                            .background(Color.mealzColor(.primary)).clipShape(Circle())
                            .shadow(radius: 2.0)
                    }
                    .darkenView(!longerThanThreeChars)
                    .disabled(!longerThanThreeChars)
                }
                .padding([.leading], 16).frame(height: 45.0)
                .padding([.trailing], 2)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1.0))
            }.padding(10)
        }
    }
}
