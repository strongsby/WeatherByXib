//
//  Cell.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 15.02.22.
//

import UIKit

final class Cell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var nameCityLable: UILabel!
    @IBOutlet private weak var temperatureLable: UILabel!
    @IBOutlet private weak var descriptionLable: UILabel!

    // MARK: - Funcs
    
    func updateAll(weatherResponce: WeatherCoreData){
        if let city = weatherResponce.city, let temp = weatherResponce.current?.temp, let description = weatherResponce.current?.attribute {
            nameCityLable.text = weatherResponce.active ? "Current place" : String(city)
        temperatureLable.text = String(format: "%.1f°", temp)
        descriptionLable.text = description
        }
    }
}


extension Cell: WeatherNibLoadable {}
