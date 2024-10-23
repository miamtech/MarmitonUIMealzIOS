//
//  MarmitonMyMealRecipeCard.swift
//
//
//  Created by Diarmuid McGonagle on 27/08/2024.
//

import Foundation
import mealzcore
import MealziOSSDK
import SwiftUI

@available(iOS 14, *)
public struct MarmitonMyMealRecipeCard: MyMealRecipeCardProtocol {
    public init() {}
    public func content(params: MyMealRecipeCardParameters) -> some View {
        let pictureSize = params.recipeCardDimensions.height - (Dimension.sharedInstance.mlPadding * 2)

        func showTimeAndDifficulty() -> Bool {
            return params.recipeCardDimensions.height >= 320
        }

        func showCTA() -> Bool {
            return params.recipeCardDimensions.height >= 225
        }

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: params.recipe.pictureURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: pictureSize, height: pictureSize)
                            .cornerRadius(Dimension.sharedInstance.mCornerRadius)
                    }
                    MealzSmallGuestView(guests: params.numberOfGuests)
                        .padding(Dimension.sharedInstance.mPadding)
                }
                .frame(width: pictureSize, height: pictureSize)
                .clipped()
                Spacer()
                    .frame(width: Dimension.sharedInstance.mPadding)
                VStack(alignment: .leading, spacing: Dimension.sharedInstance.mPadding) {
                    HStack(alignment: .top) {
                        Text(params.recipe.title)
                            .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.titleStyle)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .frame(height: 40)
                        Spacer()
                        Button {
                            params.onDeleteRecipe()
                        } label: {
                            if params.isDeleting {
                                ProgressLoader(color: Color.mealzColor(.primary), size: 20)
                            } else {
                                Image.mealzIcon(icon: .trash)
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.mealzColor(.grayText))
                            }
                        }
                    }
                    Text(String(format: String.localizedStringWithFormat(
                            Localization.myMeals.products(
                                numberOfProducts: Int32(params.numberOfProductsInRecipe)).localised,
                            params.numberOfProductsInRecipe),
                        params.numberOfProductsInRecipe))
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyMediumBoldStyle)
                        .foregroundColor(Color.mealzColor(.grayText))
                    PricePerPersonView(price: params.recipePrice, numberOfGuests: params.numberOfGuests)
                    Button(action: {
                        params.onShowRecipeDetails(params.recipe.id)
                    }, label: {
                        HStack {
                            Text(Localization.myMeals.seeProducts.localised)
                                .foregroundColor(Color.mealzColor(.primary))
                                .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyStyle)
                            Image.mealzIcon(icon: .arrow)
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.mealzColor(.primary))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                        }
                    })
                    .padding(Dimension.sharedInstance.mlPadding)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 40)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(Dimension.sharedInstance.mPadding)
        }
        .onTapGesture {
            params.onShowRecipeDetails(params.recipe.id)
        }
        .frame(height: params.recipeCardDimensions.height)
        .frame(maxWidth: .infinity)
        .cornerRadius(Dimension.sharedInstance.mCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(Color.mealzColor(.border), lineWidth: 1.0)
        )
        .padding(.horizontal, Dimension.sharedInstance.mPadding)
    }

    struct PricePerPersonView: View {
        var price: Double
        var numberOfGuests: Int

        private var pricePerPerson: Double {
            numberOfGuests != 0 ? price / Double(numberOfGuests) : 0.0
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text(price.currencyFormatted)
                    .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.titleStyle)
                    .foregroundColor(Color.mealzColor(.primary))
                    .multilineTextAlignment(.leading)
                HStack(alignment: .bottom, spacing: 2) {
                    Text(pricePerPerson.currencyFormatted)
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyMediumBoldStyle)
                        .foregroundColor(Color.mealzColor(.grayText))
                        .multilineTextAlignment(.leading)
                    Text(Localization.myMeals.perPerson.localised)
                        .miamFontStyle(style: MiamFontStyleProvider.sharedInstance.bodyMediumBoldStyle)
                        .foregroundColor(Color.mealzColor(.grayText))
                }
            }
        }
    }
}
