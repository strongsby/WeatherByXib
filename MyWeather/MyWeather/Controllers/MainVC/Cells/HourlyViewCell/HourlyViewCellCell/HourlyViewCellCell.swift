//
//  HourlyViewCellCell.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 13.02.22.
//

import UIKit

final class HourlyViewCellCell: UICollectionViewCell {
    
    static let identifire = "\(HourlyViewCellCell.self)"
    static var nib: UINib {
        UINib(nibName: "\(HourlyViewCellCell.self)", bundle: nil)
    }
    
    // MARK: - Properties
    
    @IBOutlet private weak var timeLable: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var tempLable: UILabel!
    
    // MARK: - funcs
    
    func updateAll(hourlyArray: CurrentCoreData){
        if let icon = hourlyArray.icon{
            timeLable.text = DateFormatter().getHourString(intervaleFrom1970: hourlyArray.date)
            image.image = UIImage(named: icon)
            tempLable.text = String(format: "%.1f°", hourlyArray.temp)
        }
    }
}

