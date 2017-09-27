//
//  CurrentWeather.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/19.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

// stores all of the variables that will keep track of our weather data

import UIKit
import Alamofire  // this is how you use the pods grabbed from cocoapods
// if there is an error, then press shift+command+K and then S+C+b

class CurrentWeather {

    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemperature: Double!
//    private var _highestTemp: Double!
//    private var _lowestTemp: Double!  晚點再用
    
    
    var cityName:String {
        if _cityName == nil{
            _cityName = ""
            // if there is no value, at least it won't crash(有些經緯度沒有對應國家)
            // 不是每次都用NewValue, 要看狀況
        }
        return _cityName
    }
    
    var date:String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long //option + clip可以看這是什麼
        dateFormatter.timeStyle = .none
        // by default it returns a time stamp as well
        
        let currentDate = dateFormatter.string(from: Date())
        //可以看成把剛剛設定的用String呈現
        
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType:String{
        
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }

    var currentTemperature:Double{
        
        if _currentTemperature == nil {
            _currentTemperature = 0.0
        }
        
        return _currentTemperature
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        
        // unwrapped, 我們要確保他一定有值
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)! 
        
        // get request   .responseJSON 是設定server回傳的資料型態
        // 不用completionhandler, 因為已經有設定(completed: DownloadComplete)
        // 'response in' 是回傳指令
        // conclusion: every request has response; every response has result
        Alamofire.request(currentWeatherURL).responseJSON{ response in
            let result = response.result //result是boolean
           
            // 到此以前，確定JSON是可以被成功下載下來的
            
            // 接下來就是要抓出JSON裡面我們所需要的部分
            
            // 把 result.value 轉型成 Dictionary<String, AnyObject> 的型態
            if let dictionary = result.value as? Dictionary<String, AnyObject>{
                
                // look for the key in the dictionary that we want
                if let name = dictionary["name"] as? String{
                    
                    self._cityName = name.capitalized //確定大寫
                    print(self._cityName)
                }
                
                if let weather = dictionary["weather"] as? [Dictionary<String, AnyObject>]{
                    
                    // 0 stands for the first value in the array(1st dictionary)
                    if let weathertype = weather[0]["main"] as? String{
                        
                        self._weatherType = weathertype.capitalized
                        print(self._weatherType)
                    }
                }
                
                if let main = dictionary["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currenttemperature = main["temp"] as? Double {
                        
                        let kelvinToCelsiusPre = currenttemperature - 273.15
                        
                        let kelvinToCelsius = Double(round(10 * kelvinToCelsiusPre/10))
                        
                        self._currentTemperature = kelvinToCelsius
                        
                        
                        print(self._currentTemperature)
                        
                    }
                }
            }
            
            completed() // URL裡面的東西下載完之後，func complete 即停止
        }
        
    }
    
    
    
    
    
    
    
    
}
