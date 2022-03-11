//
//  DailyViewCell.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 13.02.22.
//

import UIKit

final class DailyViewCell: UICollectionViewCell {
    
    static let identifire = "\(DailyViewCell.self)"
    static var nib: UINib {
        UINib(nibName: "\(DailyViewCell.self)", bundle: nil)
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var dayLable: UILabel!
    @IBOutlet private weak var dayImage: UIImageView!
    @IBOutlet private weak var minTepLable: UILabel!
    @IBOutlet private weak var maxTempLable: UILabel!



    // MARK: - Funcs
    
    func updateAll(daily: DailyCoreData, indexPath: IndexPath ) {
        if let icon = daily.icon {
            dayLable.text = DateFormatter().getDayString(intervaleFrom1970: daily.da)
            dayImage.image = UIImage(named: icon)
            minTepLable.text = String(format: "От %.1f°", daily.tmpMin)
            maxTempLable.text = String(format: "до %.1f°", daily.tempMax)
        }
    }
}
