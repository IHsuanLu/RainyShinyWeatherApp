//
//  WeatherVC.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/11.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

import UIKit
import CoreLocation //定位需要
import Alamofire

// protocols
// UITableViewDelegate: tells the table view how it's supposed to handle data
// UITableViewDataSource: the data
// CLLocationManagerDelegate: for 定位用

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    // tableView也要IBOutlet, 之後protocols的func會要用到
    @IBOutlet weak var tableView: UITableView!
    
    // 定位用 跟 tableView 一樣，需要到viewDidLoad設定
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // create an object of the class 'CurrentWeather'
    var currentweatherobj = CurrentWeather()
    
    // * due to we got multiple forcasts, so we need an array to accept data
    var forcasts = [Forecast]()
    
    // 先執行這裡再執行viewDidLoad
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
        
        // update UI 和 reload tableView 的部分要放到viewDidAppear，
        currentweatherobj.downloadWeatherDetails {
            // Code to update UI
            self.updateMainUI()
            
            self.downloadForecastData {
                // 把今天的去掉，看起來合理些(每次都移除第一個，array index會自動往前遞補)
                self.forcasts.remove(at: 0)
                self.forcasts.remove(at: 0)
                self.forcasts.remove(at: 0)
                self.forcasts.remove(at: 0)
                self.forcasts.remove(at: 0)
                
                // Code to update tableView
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 把所有東西都set好之後，要記得跟viewDidLoad說
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self //定位用
        
        //how accurate do you want this GPS location to be （定位用）
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // always v.s. whenInUse
        locationManager.requestWhenInUseAuthorization()
        // signifiacnt changes happens then monitor
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // how many cells do you want in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 就算有dequeueReusableCell，row的數量還是要跟array一樣
        return forcasts.count
    }
    
    // 重複複製prototype cells要用cellForRowAt{DQ}，也要幫tableViewCell設identifier
    // 從Model抓資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? weatherCell{
            
            // we need to tell 'func configureCell' which forcast should be passed in in which time!!!!
            // once a cell is created, it will get an indexParh
            let forcastDataUnit = forcasts[indexPath.row]
            cell.configureCell(forecast: forcastDataUnit)
            
            return cell
            
        } else {
            
            print("It's not working")
            //怕crash, 若沒值則回傳空的weatherCell
            return weatherCell()
        }
    }
    
    
    // 此func 後面不用帶入CurrentWeather，因為有new一個CurrentWeather的obj了
    func updateMainUI(){
        
        dateLabel.text = currentweatherobj.date
        tempLabel.text = "\(currentweatherobj.currentTemperature)"
        //用置入的(convert String to Double)
        locationLabel.text = currentweatherobj.cityName
        weatherTypeLabel.text = currentweatherobj.weatherType
        
        weatherIcon.image = UIImage(named: currentweatherobj.weatherType)
    }
    
    // we are gonna download all of the forecast data here because we have to update our table view
    
    func downloadForecastData(completed: @escaping DownloadComplete){
        // Downloading our forecast weather data for tableView
        
        let forecastURL = URL(string: FORECAST_WEATHER_URL)!
        
        Alamofire.request(forecastURL).responseJSON { response in
            
            let result = response.result
            
            if let dictionary = result.value as? Dictionary<String, AnyObject>{
               
                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>]{
                    // 把整個list的Dictionary都下載下來，再到Forecast的init找自己要的
                    // 用for each
                    for obj in list{
                        // * for every object we found in the dictionary
                        // we are adding it to another dictionary somewhere else
                        let forcast = Forecast(weatherDict: obj)
                        
                        // 所有下載的資訊都已經append到 'forcasts' 裡了
                        self.forcasts.append(forcast)
                    }
                }
            }
            
            completed()
        }
    }
    
    
    // * authorize or request authorization
    // singleton class uses static variables to let a location to be accessed throughout the app (概念有像)
    func locationAuthStatus(){
        
        // if authorized
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
           
            // 直接存取地點
            currentLocation = locationManager.location
            
            // save it into the singleton class
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        } else { // if it's not
            
            // 設定info.plist!!!!!!! privacy - location when in used(pop-out message)
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus() //跑if
        }
    }
    
}



