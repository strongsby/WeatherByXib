//
//  CityVCModelDelegate.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 11.03.22.
//

import Foundation

protocol CityVCModelDelegate {
    func cityVCReloadData()
    func cityVCShowAllert(title: String, message: String)
    func cityVCShowMainVC(city: String)
}
