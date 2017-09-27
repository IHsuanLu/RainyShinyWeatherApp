//
//  Location.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/26.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

import CoreLocation

class Location{
    
    // 不要宣告在VC 因為需要是static
    static var sharedInstance = Location()
    private init() {
    
    }
    
    var latitude: Double!
    var longitude: Double!
}
