//
//  MealzStoreLocatorWebView.swift
//
//
//  Created by Damien Walerowicz on 12/04/2024.
//

import Foundation
import mealzcore
import MealziOSSDK
import SwiftUI
import UIKit
import WebKit

public class MealzStoreLocatorWebView: UIViewController {
    var webView: WKWebView
    var contentController = WKUserContentController()
    var urlToLoad: URL
    var onSelectItem: (String?) -> Void
    
    public init(url: URL, onSelectItem: @escaping (Any?) -> Void) {
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "_allowUniversalAccessFromFileURLs")
        webView = WKWebView(frame: .zero, configuration: config)
        urlToLoad = url
        self.onSelectItem = onSelectItem
        super.init(nibName: nil, bundle: nil)
        contentController.add(self, name: "Mealz")
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.javaScriptEnabled = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        var htmlURLRequest = URLRequest(url: urlToLoad)
        htmlURLRequest.setValue("app://testWebview", forHTTPHeaderField: "Access-Control-Allow-Origin")
        if let url = htmlURLRequest.url {
            webView.loadFileURL(url, allowingReadAccessTo: urlToLoad.deletingLastPathComponent())
        }
        // send PageView Analytics event
        StoreLocatorButtonViewModel.companion.sendPageView()
    }
}

@available(iOS 15.0, *)
extension MealzStoreLocatorWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? String, let data = body.data(using: .utf8) else { return }
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let message = json["message"] as? String {
                    switch message {
                    case "posIdChange":
                        if let posId = json["posId"] as? String {
                            Mealz.User.shared.setStoreWithMealzIdWithCallBack(storeId: posId) {
                                // send pos.selected Analytics event
                                if let posName = json["posName"] as? String,
                                   let retailerId = json["supplierId"] as? String,
                                    let retailerName = json["supplierName"] as? String {
                                    StoreLocatorButtonViewModel.companion.sendPosSelectedEvent(
                                        posId: posId,
                                        posName: posName,
                                        supplierName: retailerName
                                    )
                                    Mealz.shared.user.setRetailer(
                                        retailerId: retailerId,
                                        retailerName: retailerName
                                    )
                                }
                                self.dismiss(animated: true)
                            }
                        }
                    case "showChange":
                        if !(json["value"] as? Bool ?? false) {
                            if let vc = presentingViewController {
                                dismiss(animated: true)
                                vc.dismiss(animated: true)
                            } else {
                                dismiss(animated: true)
                            }
                            break
                        }
                    default:
                        break
                    }
                }
            }
        } catch {
            print("Erreur lors de la désérialisation JSON:", error)
        }
    }
}

@available(iOS 15.0, *)
struct MealzWebViewSwiftUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = MealzStoreLocatorWebView
    
    var urlToLoad: URL
    var onSelectItem: (Any?) -> Void
    
    let mealzView: MealzStoreLocatorWebView
    init(urlToLoad: URL, onSelectItem: @escaping (Any?) -> Void) throws {
        self.urlToLoad = urlToLoad
        self.onSelectItem = onSelectItem
        mealzView = MealzStoreLocatorWebView(url: urlToLoad, onSelectItem: onSelectItem)
    }
    
    func makeUIViewController(context: Context) -> MealzStoreLocatorWebView {
        return mealzView
    }
    
    func updateUIViewController(_ uiViewController: MealzStoreLocatorWebView, context: Context) {}
}
