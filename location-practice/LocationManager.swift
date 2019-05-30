//
//  LocationManager.swift
//  location-practice
//
//  Created by jinsei_shima on 2019/05/31.
//  Copyright © 2019 jinsei_shima. All rights reserved.
//

import Foundation
import CoreLocation

public struct Location {
    
    public var index: Int = 0
    public var latitude: Double
    public var longitude: Double
    public var createdAt: Date = Date(timeIntervalSince1970: 1)
//    public var distance: Double = 0.0
    public var accuracy: Double
    
    init(latitude: Double, longitude: Double, createdAt: Date, horizontalAccuracy: Double) {
        
//        let realm = try! Realm()
//        let lastLocation: Location? = realm.objects(Location.self).sorted(byKeyPath: "index").last
//        if let index = lastLocation?.index {
//            self.index = index + 1
//        }
//
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
//        let preLocation: Location = self.preLocation()
//        self.distance = distance(locate1: self, locate2: preLocation)
        self.accuracy = horizontalAccuracy
        
    }
    
//    public static func loadStoredLocations() -> [Location] {
//
//        let realm = try! Realm()
//        let locations: Results<Location> = realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
//        return Array(locations)
//    }
    
//    public static func totalDistance() -> Double {
//
//        let locations: [Location] = loadStoredLocations()
//        var total: Double = 0.0
//        for location in locations {
//            total += location.distance
//        }
//        total = total/1000 // to km
//        return total
//    }
    
    public func geoCoder(completion:@escaping (String) -> (Void)) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil { completion(error.debugDescription) }
            if let place = placemarks?.first {
                //                let locality = place.locality ?? ""
                //                let subLocality = place.subLocality ?? ""
                let thoroughfare = place.thoroughfare ?? ""
                let subThoroughfare = place.subThoroughfare ?? ""
                //                completion("\(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)")
                completion("\(thoroughfare) \(subThoroughfare)")
            }
        })
    }
    
    public func distance(locate1: Location, locate2: Location) -> Double {
        
        let _locate1: CLLocation = CLLocation(latitude: locate1.latitude, longitude: locate1.longitude)
        let _locate2: CLLocation = CLLocation(latitude: locate2.latitude, longitude: locate2.longitude)
        return _locate1.distance(from: _locate2)
    }
    
//    public func preLocation() -> Location {
//
//        let realm = try! Realm()
//        let preLocation: Location = realm.object(ofType: Location.self, forPrimaryKey: index-1) ?? self
//        return preLocation
//    }
}

public class LocationManager: CLLocationManager {
    
    public static var sharedInstance: LocationManager = LocationManager()
    
    override init() {
        
        super.init()
        
        delegate = self
        pausesLocationUpdatesAutomatically = true
        allowsBackgroundLocationUpdates = true
        desiredAccuracy = kCLLocationAccuracyBest
        distanceFilter = 100
        activityType = CLActivityType.fitness
    }
    
    public func startSignificantLocation() {
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied {
            return
        }
        if status == CLAuthorizationStatus.notDetermined {
            requestAlwaysAuthorization()
        }
        
        if significantLocationAvailable() {
            startMonitoringSignificantLocationChanges()
        }
    }
    
    public func stopSignificantLocation() {
        
        stopMonitoringSignificantLocationChanges()
    }
    
    public func significantLocationAvailable() -> Bool {
        
        return CLLocationManager.significantLocationChangeMonitoringAvailable()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else { return }
        
        if newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 100 { return }
        
//        let coordinate = newLocation.coordinate
        
//        let location = Location(latitude: <#Double#>)
//        location.setData(latitude: coordinate.latitude, longitude: coordinate.longitude, createdAt: Date(), horizontalAccuracy: newLocation.horizontalAccuracy)
//
//        print(location)
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(location)
//        }
        
//        Notification.notification(title: "Movement", subTitle: "didUpdateLocations", body: location.debugDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
//        Notification.notification(title: "Movement", subTitle: "didFailWithError", body: error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            
            break
        case .authorizedWhenInUse:
            
            break
        case .denied:
            
            break
        case .notDetermined:
            
            requestAlwaysAuthorization()
            break
        case .restricted:
            
            break
            
        @unknown default:
            
            fatalError()
            
        }
    }
}

