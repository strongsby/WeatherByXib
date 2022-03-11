//
//  UITableView+register+dequeueReusableCell.swift
//  MyWeather
//
//  Created by Сергей Рудинский on 10.03.22.
//

import UIKit


extension UITableView {
    
    func register<CellType: UITableViewCell>(type: CellType) {
        let nib = UINib(nibName: "\(CellType.self)", bundle: nil)
        register(nib, forCellReuseIdentifier: "\(CellType.self)")
    }
    
    func dequeueReusableCells<CellType: UITableViewCell>(with type: CellType, indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withIdentifier: "\(CellType.self)", for: indexPath) as! CellType
    }
    
}
