//
//  LocationManager.swift
//  Core
//
//  Created by 유지호 on 6/5/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation
import CoreLocation

public final class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    public var userLocation: CLLocation = .init(latitude: 37.4979278, longitude: 127.0275833)
      
    public var latitude: Double {
        userLocation.coordinate.latitude
    }
    
    public var longitude: Double {
        userLocation.coordinate.longitude
    }
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    public func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startUpdate() {
        manager.startUpdatingLocation()
    }
    
    public func stopUpdate() {
        manager.stopUpdatingLocation()
    }
    
}


extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdate()
        case .notDetermined:
            requestAuthorization()
        case .denied, .restricted:
            stopUpdate()
            debugPrint("사용자 위치 권한 필요")
        @unknown default:
            debugPrint("Unknown Location Authorization")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        debugPrint(error.localizedDescription)
    }
    
}
