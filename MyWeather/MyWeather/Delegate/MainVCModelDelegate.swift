//
//  MainVCModelDelegate.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 11.03.22.
//

import Foundation


protocol MainVCModelDelegate {
    func mainVCShowAllert(title: String, message: String)
    func mainVCCollectionViewReloadData()
}
