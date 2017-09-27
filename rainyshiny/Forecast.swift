//
//  Forecast.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/21.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
 
    private var _time: String!
    private var _weatherType: String!
    private var _highTemp: Double!
    private var _lowTemp: Double!
    
    var time:String {
        if _time == nil {
            _time = ""
        }
        return _time
    }
    
    var weatherType:String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var highTemp:Double {
        if _highTemp == nil{
            _highTemp = 0.0
        }
        return _highTemp
    }
    
    var lowtemp:Double {
        if _lowTemp == nil{
            _lowTemp = 0.0
        }
        return _lowTemp
    }
    
    // create an initializer that will pull the data that we've downloaded into our Forecast class
    // and its gonna run it through and set all those values
    
    init(weatherDict: Dictionary<String, AnyObject>){
        
        if let main = weatherDict["main"] as? Dictionary<String, AnyObject>{
        
            if let min = main["temp_min"] as? Double{
            
                let kelvinToCelsiusPre = min - 273.15
                
                let kelvinToCelsius = Double(round(10 * kelvinToCelsiusPre/10))
                
                self._lowTemp = kelvinToCelsius

            }
            
            if let max = main["temp_max"] as? Double{
                
                let kelvinToCelsiusPre = max - 273.15
                
                let kelvinToCelsius = Double(round(10 * kelvinToCelsiusPre/10))
                
                self._highTemp = kelvinToCelsius
            }
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>]{
        
            if let main = weather[0]["main"] as? String{
                
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt_txt"] as? String{
            
            let dateFormatter = DateFormatter()
            
            //This is the date string pattern match we are sending in from JSON
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //Convert our JSON date string to a Date type
            let dateString = dateFormatter.date(from: date)
            
            //Now rematch our expected output style
            dateFormatter.dateFormat = "MM/dd, HH:mm" //Shows only the hour and a AM/PM indicator
            //Update our data model now            
            self._time = "\(dateFormatter.string(from: dateString!))"
        }
        
        // dt 那串數字是可以被轉換成日期的！！
        //用Date(timeIntervalSince1970: ) + Date Extension
//        if let dateTest = weatherDict["dt"] as? Double{
//            
//            let unixConvertedDate = Date(timeIntervalSince1970: dateTest)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE"
//            dateFormatter.dateStyle = .long
//            dateFormatter.timeStyle = .none
//            
//            print(unixConvertedDate)
//            self._time = unixConvertedDate.dayOfTheWeek()
//        }
    }
    
}

//當API上面沒給日期時，可以用extension Date來取用(swift本身的)
//should be build outta class
//extension Date{
//    func dayOfTheWeek() -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE" //means I want the full name of the day
//        
//        // it's self because we're getting the date in the viewController
//        return dateFormatter.string(from: self)
//        
//    }
//}


