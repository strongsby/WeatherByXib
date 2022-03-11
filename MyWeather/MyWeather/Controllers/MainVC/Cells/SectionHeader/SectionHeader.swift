//
//  SectionHeader.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 13.02.22.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    // MARK: - Outlets
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var label: UILabel!
 
    // MARK: - funcs
    
    func configurateHeader(text: String, headerImage: UIImage){
        label.text = text
        image.image = headerImage
        }
    }


extension SectionHeader: WeatherNibLoadable {}
