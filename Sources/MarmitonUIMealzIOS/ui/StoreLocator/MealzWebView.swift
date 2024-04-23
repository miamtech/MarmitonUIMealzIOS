//
//  File.swift
//  
//
//  Created by Damien Walerowicz on 12/04/2024.
//

import Foundation
import UIKit
import WebKit
import SwiftUI

@available(iOS 15.0, *)
public class MealzWebView: UIViewController {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
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
        
        webView.loadFileRequest(htmlURLRequest, allowingReadAccessTo: urlToLoad.deletingLastPathComponent())
    }
}
@available(iOS 15.0, *)
extension MealzWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? String, let data = body.data(using: .utf8) else { return }
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let message = json["message"] as? String, let value = json["value"] as? String {
                    
                    switch(message) {
                    case "posIdChange":
                        self.onSelectItem(value)
                        self.dismiss(animated: true)
                    default:
                        break;
                    }
                    print("Message:", message)
                    print("Value:", value)
                }
            }
        }catch {
            print("Erreur lors de la désérialisation JSON:", error)

        }
        
        
        
       
       
    }
}
@available(iOS 15.0, *)
struct MealzWebViewSwiftUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = MealzWebView
    
    var urlToLoad: URL
    var onSelectItem: (Any?) -> Void
    
    let mealzView: MealzWebView
    init(urlToLoad : URL, onSelectItem: @escaping (Any?) -> Void) throws {
        self.urlToLoad = urlToLoad
        self.onSelectItem = onSelectItem
        mealzView = MealzWebView(url: urlToLoad, onSelectItem: onSelectItem)
    }
    
    func makeUIViewController(context: Context) -> MealzWebView {
        return mealzView
    }
    
    func updateUIViewController(_ uiViewController: MealzWebView, context: Context) {
        
    }
}
