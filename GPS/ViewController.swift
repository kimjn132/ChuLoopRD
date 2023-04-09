//
//  ViewController.swift
//  GPS
//
//  Created by Anna Kim on 2023/01/25.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var labelLocationInfo1: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var latitude1 = 0.0
    var longtitude1 = 0.0
    
    // MARK: - 위도 경도를 주소로 변환시켜주는 함수 갖고오기
    lazy var geocoder = CLGeocoder()
    
    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        title = "Reverse Geocoding"
    }
    

    
    
    // 위치 정확도를 높여주는 함수(사용자가 gps를 허용할 때 함수를 실행)
    lazy var locationManager: CLLocationManager = {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
            manager.delegate = self
            return manager
         }()

        var previousCoordinate: CLLocationCoordinate2D?
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        ls.requestAlwaysLocation()
        
        getLocationUsagePermission()
        
        
        
        // xcode 종료 후 어플을 다시 실행했을 때 뜨는 오류 방지.
        self.MapView.mapType = MKMapType.standard
        // 지도에 내 위치 표시
        MapView.showsUserLocation = true
        // 현재 내 위치 기준으로 지도를 움직임.
        self.MapView.setUserTrackingMode(.follow, animated: true)

        self.MapView.isZoomEnabled = true
        self.MapView.delegate = self

//      self.trackData.date = Date()
        
        
        
    }
    
    
    
    @IBAction func showAdress_btn(_ sender: UIButton) {
        
        //geocoding(reverse)
        let lat = latitude1
        let lng = longtitude1
        
        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)
        
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
            print("placemarks : \(self.processResponse(withPlacemarks: placemarks, error: error))")
        }
        
    }
    
    
    
    
    func getLocationUsagePermission() {
            self.locationManager.requestWhenInUseAuthorization()
        }

        override func viewWillDisappear(_ animated: Bool) {
            self.locationManager.stopUpdatingLocation()
            
        
            
        }


    //Geocoding
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            lblAddress.text = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                lblAddress.text = placemark.compactAddress
                
            } else {
                lblAddress.text = "No Matching Addresses Found"
            }
        }
    }
    

}


extension ViewController: CLLocationManagerDelegate {
    
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            switch status {
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("GPS 권한 설정됨")
//            case .restricted, .notDetermined:
//                print("GPS 권한 설정되지 않음")
//                DispatchQueue.main.async {
//                    self.getLocationUsagePermission()
//                }
//            case .denied:
//                print("GPS 권한 요청 거부됨")
//                DispatchQueue.main.async {
//                    self.getLocationUsagePermission()
//                }
//            default:
//                print("GPS: Default")
//            }
//        }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {


        guard let location = locations.last
        else {return}
        latitude1 = location.coordinate.latitude
        longtitude1 = location.coordinate.longitude

        
        self.labelLocationInfo1?.text
            = "\(latitude1)/\(longtitude1)"
        
        
        if let previousCoordinate = self.previousCoordinate {
            
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude1, longtitude1)
            points.append(point1)
            points.append(point2)
            
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            self.MapView.addOverlay(lineDraw)
        }

        self.previousCoordinate = location.coordinate

    }
}


extension ViewController: MKMapViewDelegate {
    
    // gps사용 이동 선 그리기
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .orange
            renderer.lineWidth = 5.0
            renderer.alpha = 1.0

        return renderer
    }
}
