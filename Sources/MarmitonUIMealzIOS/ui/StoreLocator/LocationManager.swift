//
//  LocationManager.swift
//  MarmitonUIMealzIOS
//
//  Created by didi on 26/12/2024.
//

import Foundation
import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    public var onLocationUpdate: ((CLLocation) -> Void)?
    public var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // Request location permissions
    public func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Start updating the location
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // Stop updating the location
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // Delegate method for location updates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onLocationUpdate?(location)
    }

    // Delegate method for authorization changes
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            onAuthorizationChange?(manager.authorizationStatus)
        } else {
            // Fallback for older versions
            onAuthorizationChange?(CLLocationManager.authorizationStatus())
        }
    }
    
    // Provide current permission status explicitly
    public func setPermissionFromClientApp(status: CLAuthorizationStatus) {
        // Pass the provided permission status to the authorization change callback
        onAuthorizationChange?(status)
        
        // Start location updates if necessary
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            print("location: Location access not granted. Current status: \(status)")
        }
    }

    // Delegate method for errors
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
