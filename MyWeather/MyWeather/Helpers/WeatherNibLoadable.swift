//
//  WeatherNibLoadable.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 11.03.22.
//

import UIKit

protocol WeatherNibLoadable {
    
    static var defaultNibName: String { get }
    static func loadFromNib() -> Self
    
}

extension WeatherNibLoadable where Self: UIView {
    
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: nil)
    }
    
    static func loadFromNib() -> Self {
        guard let nib = Bundle.main.loadNibNamed(defaultNibName, owner: nil, options: nil)?.first as? Self else {
            fatalError("[BIPNibLoadable] Cannot load view from nib.")
        }
        return nib
    }
    
}

extension WeatherNibLoadable where Self: UIViewController {
    
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: nil)
    }
    
    static func loadFromNib() -> Self {
        guard let nib = Bundle.main.loadNibNamed(defaultNibName, owner: nil, options: nil)?.first as? Self else {
            fatalError("[BIPNibLoadable] Cannot load view from nib.")
        }
        return nib
    }
    
}

extension WeatherNibLoadable where Self: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
}


extension WeatherNibLoadable where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
}


extension WeatherNibLoadable where Self: UICollectionReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}
