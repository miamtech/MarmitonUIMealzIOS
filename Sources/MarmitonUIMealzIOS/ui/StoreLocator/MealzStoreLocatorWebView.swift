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
        let userScript = WKUserScript(
            source: logInjectionScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
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
            webView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            webView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        var htmlURLRequest = URLRequest(url: urlToLoad)
        htmlURLRequest
            .setValue(
                "app://testWebview",
                forHTTPHeaderField: "Access-Control-Allow-Origin"
            )
        if let url = htmlURLRequest.url {
            webView
                .loadFileURL(
                    url,
                    allowingReadAccessTo: urlToLoad.deletingLastPathComponent()
                )
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
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        LogHandler.companion.info("Received message body: \(message.body)")

        guard let body = message.body as? String, let data = body.data(using: .utf8) else {
            return
        }
        do {
            // this is basic console logs from HTML, not events
            if body.contains("[Mealz components]") { return }
            // Parse JSON
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                LogHandler.companion.warn("Failed to parse JSON")
                return
            }

            // Extract message type
            guard let messageType = json["message"] as? String else {
                LogHandler.companion.warn("Message type not found in JSON")
                return
            }

            // Handle the message based on its type
            handleMessage(type: messageType, payload: json)
        } catch {
            LogHandler.companion.error("Error parsing JSON: \(error)")
        }
    }
    
    private func handleMessage(type: String, payload: [String: Any]) {
        switch type {
        case "posIdChange":
            handlePosIdChange(payload: payload)
        case "showChange":
            handleShowChange(payload: payload)
        case "searchChange":
            handleLocatorSearch(payload: payload)
        case "filterChange":
            handleFilterChange(payload: payload)
        case "mapSelected":
            StoreLocatorButtonViewModel.companion.sendDisplayMapEvent()
        case "listSelected":
            StoreLocatorButtonViewModel.companion.sendDisplayListEvent()
        default:
            LogHandler.companion.warn("Unhandled message type: \(type)")
        }
    }

    private func handlePosIdChange(payload: [String: Any]) {
        guard let posId = payload["posId"] as? String else {
            LogHandler.companion.error("Missing posId in payload")
            return
        }
      
        if PointOfSaleRepositoryCompanion().pointOfSaleMealzId == posId {
            dismiss(animated: true)
        } else {
          Mealz.User.shared.setStoreWithMealzIdWithCallBack(storeId: posId) {
              if let posName = payload["posName"] as? String,
                 let retailerId = payload["supplierId"] as? String,
                 let retailerName = payload["supplierName"] as? String {
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
    }

    private func handleShowChange(payload: [String: Any]) {
        guard let isBeingShown = payload["value"] as? Bool else {
            LogHandler.companion.warn("Missing or invalid 'value' in payload")
            return
        }

        if !isBeingShown {
            StoreLocatorButtonViewModel.companion.sendLocatorBackEvent()
            if let vc = presentingViewController {
                dismiss(animated: true)
                vc.dismiss(animated: true)
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    // ------------------ ANALYTICS ---------------------------------------
    
    private func handleLocatorSearch(payload: [String: Any]) {
        guard let searchTerm = payload["searchTerm"] as? String else {
            LogHandler.companion.warn("Missing searchTerm in payload")
            return
        }
        guard let numberOfResults = payload["numberOfResults"] as? Int else {
            LogHandler.companion.warn("Missing numberOfResults in payload")
            return
        }
        StoreLocatorButtonViewModel.companion.sendLocatorSearchEvent(
            searchTerm: searchTerm,
            numStoreFound: Int32(numberOfResults)
        )
    }
    
    private func handleFilterChange(payload: [String: Any]) {
        guard let supplierName = payload["supplierName"] as? String else {
            LogHandler.companion.warn("Missing supplierName in payload")
            return
        }
        StoreLocatorButtonViewModel.companion
            .sendLocatorFilterEvent(supplierName: supplierName)
    }
}

extension MealzStoreLocatorWebView {
    func passCoordsToWebView(latitude: String, longitude: String) {
        let jsCode = "searchBasedOnGeoLocation('\(latitude)', '\(longitude)');"
        
        // Execute the JavaScript in the WebView
        webView.evaluateJavaScript(jsCode) { result, error in
            if let error = error {
                LogHandler.companion.error("Error calling JavaScript: \(error)")
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
        mealzView = MealzStoreLocatorWebView(
            url: urlToLoad,
            onSelectItem: onSelectItem
        )
    }
    
    func makeUIViewController(context: Context) -> MealzStoreLocatorWebView {
        return mealzView
    }
    
    func updateUIViewController(
        _ uiViewController: MealzStoreLocatorWebView,
        context: Context
    ) {
    }
}
