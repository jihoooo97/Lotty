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
    
    public var location: CLLocation?
    
    public var latitude: Double {
        location?.coordinate.latitude ?? 0.0
    }
    
    public var longitude: Double {
        location?.coordinate.longitude ?? 0.0
    }
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.pausesLocationUpdatesAutomatically = false
//        manager.requestWhenInUseAuthorization()
    }
    
    public func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startUpdate() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    public func stopUpdate() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("권한 요청 거부됨")
            stopUpdate()
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdate()
        @unknown default: return
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    
    
}
