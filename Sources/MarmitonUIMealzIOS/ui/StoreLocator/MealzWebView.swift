//
//  File.swift
//  
//
//  Created by Damien Walerowicz on 12/04/2024.
//

import Foundation


class MealzWebView: UIViewController {
    var webView: WKWebView
    var contentController = WKUserContentController()
    
    var urlToLoad: URL
    
    var onSelectItem: () -> Any?
    
    init(url: URL, onSelectItem: @escaping () -> Any?) {
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "_allowUniversalAccessFromFileURLs")
        webView = WKWebView(frame: .zero, configuration: config)
        urlToLoad = url
        self.onSelectItem = onSelectItem
        super.init(nibName: nil, bundle: nil)
        contentController.add(self, name: "mealz")
        webView.isInspectable = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.javaScriptEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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

extension MealzWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("userContentController")
    }
}


struct MealzWebViewSwiftUI: UIViewControllerRepresentable {
   
    
    typealias UIViewControllerType = MealzWebView
    
    var urlToLoad: URL
    var onSelectItem: () -> Any?
    
    let mealzView: MealzWebView
    init(urlToLoad : URL, onSelectItem: @escaping () -> Any?) throws {
        self.urlToLoad = urlToLoad
        self.onSelectItem = onSelectItem
        
        mealzView = MealzWebView(url: urlToLoad, onSelectItem: {
            
        })
    }
    
    
    func makeUIViewController(context: Context) -> MealzWebView {
        return mealzView
    }
    
    func updateUIViewController(_ uiViewController: MealzWebView, context: Context) {
        
    }
}
