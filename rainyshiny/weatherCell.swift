//
//  weatherCell.swift
//  rainyshiny
//
//  Created by 呂易軒 on 2017/9/26.
//  Copyright © 2017年 呂易軒. All rights reserved.
//

import UIKit
import Alamofire

// 有關 protocol cells 的東西都放在這裡
class weatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon:UIImageView!
    @IBOutlet weak var forecastDate: UILabel!
    @IBOutlet weak var forecastWeatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    
    // set up data from our forecast class
    // 還要回去weatherVC設定在正確的時間貼上正確的資訊！
    // 沒有viewDidLoad(), 就要func後面帶入相關class, 不能用new object的形式
    func configureCell(forecast: Forecast){
        
        highTemp.text = "\(forecast.highTemp)"
        lowTemp.text = "\(forecast.lowtemp)"
        forecastDate.text = forecast.time
        forecastWeatherType.text = forecast.weatherType
        
        weatherIcon.image = UIImage(named: forecast.weatherType)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
