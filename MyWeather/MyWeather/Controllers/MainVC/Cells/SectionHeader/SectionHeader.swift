//
//  SectionHeader.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 13.02.22.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    
    static let identifire = "\(SectionHeader.self)"
    static var nib: UINib {
        UINib(nibName: "\(SectionHeader.self)", bundle: nil)
    }

    // MARK: - Outlets
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var label: UILabel!
 
    // MARK: - funcs
    
    func configurateHeader(text: String, headerImage: UIImage){
        label.text = text
        image.image = headerImage
        }
    }
