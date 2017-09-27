//
//  Constants.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/19.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

// constants (會需要用到的東西都放在這裡)
import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATTITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "f4e5fe5794b6d16739e3cc01a858fe6f"

// this is going to tell our function when we are complete/finished downloading
typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATTITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

let FORECAST_WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=f4e5fe5794b6d16739e3cc01a858fe6f"
