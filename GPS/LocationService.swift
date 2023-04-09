//
//  LocationService.swift
//  GPS
//
//  Created by Anna Kim on 2023/01/26.
//

import Foundation

import CoreLocation
 
class LocationService: NSObject {
    static let shared = LocationService()
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    var locationManager: CLLocationManager!
}
 

extension LocationService {
    func registLocation() {
        let location = CLLocationCoordinate2D(latitude: 37.4967867, longitude: 126.9978993)
        let region = CLCircularRegion(center: location, radius: 100.0, identifier: "id")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: region)
        print("region regist: \(region)")
    }
}
 
extension LocationService: CLLocationManagerDelegate {
    
    // 위치정보허용 설정 요청
    func requestAlwaysLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:    //권한 설정 안됨
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:  //앱 사용 중 허용
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways: // 권한 항상 허용
            registLocation()
        default:
            print("Location is not avaiable.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStartMonitoringFor")
    }
    
    
    //앱 푸시용 함수(아직 사용 안함)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            print("들어왔습니다.")
        case .outside:
            print("나왔습니다.")
        case .unknown: break
            // do not something
        }
    }
}
