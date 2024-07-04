//
//  MarmitonMyProductsProductCard.swift
//
//
//  Created by Diarmuid McGonagle on 04/07/2024.
//

import SwiftUI
import mealzcore
import MealziOSSDK
import MealzUIiOSSDK

@available(iOS 14, *)
public struct MarmitonMyProductsProductCard: MyProductsProductCardProtocol {
    public init() {}
    public func content(params: MyProductsProductCardParameters) -> some View {
        return VStack(spacing: 0) {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    MealzProductBase.productImage(pictureURL: params.data.pictureURL, width: 100, height: 100)
                        .cornerRadius(8)
                    VStack(alignment: .leading, spacing: 4) {
                        MealzMyProductsProductCard.productName(name: params.data.name)
                        HStack {
                            IngredientUnitBubble(capacity: params.data.capacity)
                            MealzMyProductsProductCard.showUnitOfMeasurement(
                                pricePerUnitOfMeasurement: params.data.pricePerUnitOfMeasurement,
                                productUnit: params.data.productUnit)
                        }
                        MealzMyProductsProductCard.replaceButton(
                            numberOfRecipesSharingThisIngredient: params.data.numberOfRecipesSharingThisIngredient,
                            replaceProduct: params.onReplaceProduct)
                        .padding(.top, 4)
                        Spacer()
                    }
                    Spacer()
                }
                HStack {
                    MealzProductBase.productPrice(formattedProductPrice: params.data.formattedProductPrice)
                    Spacer()
                    MarmitonRecipeDetailsAddedProductView.MarmitonProductCounter(
                        productQuantity: params.data.productQuantity,
                        isLocked: params.isLocked,
                        updateQuantity:  params.updateQuantity)
                }
            }
            .padding(Dimension.sharedInstance.lPadding)
            Divider()
        }
    }
}
