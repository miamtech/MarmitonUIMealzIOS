//
//  MarmitonMyBasketTitle.swift
//
//
//  Created by Diarmuid McGonagle on 04/04/2024.
//

import MealziOSSDK
import SwiftUI

/*
 @available(iOS 14, *)
 <<<<<<< HEAD
 public struct MarmitonMyBasketTitle: MyBasketTitleProtocol {
 =======
 public struct MarmitonMyBasketTitle: BaseTitleProtocol {
     let viewOptions: StoreLocatorSectionViewOptions?
 >>>>>>> 1a3448d (Add possibility to customize StoreLocator inside Basket Title component)
     let changeStore: () -> Void

     public init(
         viewOptions: StoreLocatorSectionViewOptions? = nil,
         changeStore: @escaping () -> Void
     ) {
         self.viewOptions = viewOptions
         self.changeStore = changeStore
     }
     public func content(params: MyBasketTitleParameters) -> some View {
         VStack {
 <<<<<<< HEAD
             MarmitonChangeStoreButton(changeStore: changeStore)
             MealzMyBasketTitle().content(params: params)
 =======
             StoreLocatorSection(params: StoreLocatorSectionParameters(
                 viewOptions: viewOptions ?? StoreLocatorSectionViewOptions(),
                 actions: StoreLocatorButtonActions(changeStore: changeStore)
             ))
             MealzMyMealsTitle().content(params: params)
 >>>>>>> 1a3448d (Add possibility to customize StoreLocator inside Basket Title component)
         }
     }
 }
 */
