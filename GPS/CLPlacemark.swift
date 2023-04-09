//
//  CLPlacemark.swift
//  Geocoding
//
//  Created by Bart Jacobs on 13/06/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        
        // 동
        let sublocal = subLocality
        // 시
        let local = locality
        
        
        
        // 주소 (동, 시) 같이 출력하기 / 예) 풍산동, 하남시
        let result = "\(sublocal ?? "-"), \(local ?? "-")"
        
        return result
    }
    
}
