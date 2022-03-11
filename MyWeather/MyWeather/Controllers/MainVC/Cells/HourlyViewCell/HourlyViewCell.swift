

import UIKit

final class HourlyViewCell: UICollectionViewCell {
        
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionViewRegisterCell()
        }
    }
    var hourlyArray = [CurrentCoreData]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Funcs

    private func collectionViewRegisterCell(){
        collectionView.register(HourlyViewCellCell.defaultNib , forCellWithReuseIdentifier: HourlyViewCellCell.reuseIdentifier)
    }
    
    func updateAll(hourlyArray: [CurrentCoreData]){
        self.hourlyArray = hourlyArray
    }
}
    


    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HourlyViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyViewCellCell.reuseIdentifier, for: indexPath) as! HourlyViewCellCell
        cell.updateAll(hourlyArray: self.hourlyArray[indexPath.item])
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension HourlyViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.bounds.width - 10) / 5, height: self.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}


extension HourlyViewCell: WeatherNibLoadable {}



