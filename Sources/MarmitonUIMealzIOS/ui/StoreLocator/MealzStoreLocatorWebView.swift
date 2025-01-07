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
import CoreLocation

public class MealzStoreLocatorWebView: UIViewController {
    var webView: WKWebView
    var contentController = WKUserContentController()
    var urlToLoad: URL
    private let locationManager = LocationManager()
    var onSelectItem: (String?) -> Void
    
    public init(url: URL, onSelectItem: @escaping (Any?) -> Void) {
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        webView = WKWebView(frame: .zero, configuration: config)
        urlToLoad = url
        self.onSelectItem = onSelectItem
        super.init(nibName: nil, bundle: nil)
        contentController.add(self, name: "Mealz")
        
        // Add consoleLog handler for logging
        contentController.add(self, name: "consoleLog")
        
        // Inject JavaScript for console.log interception
        let logInjectionScript = """
        (function() {
            const oldLog = console.log;
            console.log = function(...args) {
                window.webkit.messageHandlers.consoleLog.postMessage(args.join(' '));
                oldLog.apply(console, args);
            };
        })();
        """
        let userScript = WKUserScript(source: logInjectionScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
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
        
        // Check current permission status
        let currentStatus = CLLocationManager.authorizationStatus()

        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
            // Permission is already granted
            locationManager.setPermissionFromClientApp(status: currentStatus)
        } else {
            // Request permissions
            locationManager.requestLocationPermissions()
        }

        // Handle location updates
        locationManager.onLocationUpdate = { location in
            // we have to make sure the webview has shown & JS enabled so we wait 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.passCoordsToWebView(
                    latitude: String(location.coordinate.latitude),
                    longitude: String(location.coordinate.longitude))
                // stop listening
                self.locationManager.stopUpdatingLocation()
            }
        }

        // Handle authorization changes
        locationManager.onAuthorizationChange = { status in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted.")
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location access denied.")
            default:
                break
            }
        }
    }
}

@available(iOS 15.0, *)
extension MealzStoreLocatorWebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message body:", message.body)

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
                                    StoreLocatorButtonViewModel.companion.sendLocatorSelectEvent(
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
        }
    }
}

extension MealzStoreLocatorWebView {
    func passCoordsToWebView(latitude: String, longitude: String) {
        let jsCode = "searchBasedOnGeoLocation('\(latitude)', '\(longitude)');"
        
        // Execute the JavaScript in the WebView
        webView.evaluateJavaScript(jsCode) { result, error in
            if let error = error {
                print("Error calling JavaScript:", error)
            }
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
