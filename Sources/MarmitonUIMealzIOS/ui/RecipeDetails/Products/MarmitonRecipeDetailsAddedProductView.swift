//
//  MarmitonRecipeDetailsAddedProductView.swift
//
//
//  Created by Diarmuid McGonagle on 03/07/2024.
//

import SwiftUI
import MealziOSSDK
import mealzcore

public let mealzProductHeight: CGFloat = 230

@available(iOS 14, *)
public struct MarmitonRecipeDetailsAddedProductView: RecipeDetailsAddedProductProtocol {
    public init() {}
    let dim = Dimension.sharedInstance
    public func content(params: RecipeDetailsAddedProductParameters) -> some View {
        VStack {
            MealzProductBase.ingredientNameAndAmount(
                ingredientName: params.data.ingredientName,
                ingredientUnit: params.data.ingredientUnit,
                ingredientQuantity: params.data.ingredientQuantity,
                isInBasket: true)
            HStack {
                MealzProductBase.productImage(pictureURL: params.data.pictureURL)
                MealzProductBase.productTitleDescriptionWeightReplace(
                    brand: params.data.brand,
                    name: params.data.name,
                    capacity: params.data.capacity,
                    isSponsored: params.data.isSponsored,
                    onChooseProduct: params.onChangeProduct)
            }
            HStack(spacing: Dimension.sharedInstance.lPadding) {
                MealzProductBase.productPrice(formattedProductPrice: params.data.formattedProductPrice)
                Spacer()
                MarmitonProductCounter(
                    productQuantity: params.data.productQuantity,
                    isLocked: params.updatingQuantity,
                    updateQuantity: params.updateProductQuantity)
            }
            .padding(.horizontal, dim.mlPadding)
            Spacer()
            MealzProductBase.showNumberOfSharedRecipes(
                numberOfOtherRecipesSharingThisIngredient: params.data.numberOfOtherRecipesSharingThisIngredient)
        }
        .frame(height: mealzProductHeight)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: dim.mCornerRadius)
                .stroke(Color.mealzColor(.primary), lineWidth: 1)
        )
        .padding(.horizontal, dim.mPadding)
    }
    
    public struct MarmitonProductCounter: View {
        let productQuantity: Int
        let isLocked: Bool
        var updateQuantity: (Int) -> Void
        
        public init(productQuantity: Int, isLocked: Bool, updateQuantity: @escaping (Int) -> Void) {
            self.productQuantity = productQuantity
            self.isLocked = isLocked
            self.updateQuantity = updateQuantity
        }
        
        let boxWidth: CGFloat = 35
        let boxHeight: CGFloat = 35
        
        public var body: some View {
            HStack(spacing: 0) {
                Button {
                    updateQuantity(productQuantity - 1)
                } label: {
                    Image.mealzIcon(icon: .minus)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.mealzColor(.standardDarkText))
                }
                .disabled(isLocked)
                .frame(width: boxWidth, height: boxHeight, alignment: .center)
                Divider()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(Color.mealzColor(.lightGray))
                Group {
                    if isLocked {
                        ProgressLoader(color: Color.mealzColor(.standardDarkText), size: 10)
                            .foregroundColor(Color.mealzColor(.primary))
                    } else {
                        Text(String(productQuantity)).frame(alignment: .center)
                            .foregroundColor(Color.mealzColor(.primary))
                    }
                }.frame(width: boxWidth, height: boxHeight, alignment: .center)
                Divider()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(Color.mealzColor(.lightGray))
                Button {
                    updateQuantity(productQuantity + 1)
                } label: {
                    Image.mealzIcon(icon: .plus)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.mealzColor(.standardDarkText))
                }
                .disabled(isLocked)
                .frame(width: boxWidth, height: boxHeight, alignment: .center)
            }
            .frame(height: boxHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.mealzColor(.lightGray), lineWidth: 1)
                )
            .padding(.vertical, Dimension.sharedInstance.mPadding)
        }
    }
}
