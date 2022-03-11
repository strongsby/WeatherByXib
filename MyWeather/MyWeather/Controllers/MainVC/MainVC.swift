

import UIKit
import CoreLocation
import CoreData

final class MainVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var nameCityLable: UILabel!
    @IBOutlet private weak var temperatureLable: UILabel!
    @IBOutlet private weak var descriptionLable: UILabel!
    @IBOutlet private weak var bar: UINavigationBar! {
        didSet { bar.isHidden = !viewModel.updateLocation }
    }
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet { cancelButton.isHidden = viewModel.updateLocation }
    }
    @IBOutlet private weak var addButton: UIButton! {
        didSet { addButton.isHidden = viewModel.updateLocation }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionViewRegisterCell()
        }
    }
    
    // MARK: - Model
    
    var viewModel: MainViewModelProtocol = MainViewModel()


    // MARK: - Register Cells

    private func collectionViewRegisterCell(){
        collectionView.register( DailyViewCell.defaultNib , forCellWithReuseIdentifier: DailyViewCell.reuseIdentifier)
        collectionView.register(SectionHeader.defaultNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(HourlyViewCell.defaultNib, forCellWithReuseIdentifier: HourlyViewCell.reuseIdentifier)
    }

    // MARK: - funcs

    @IBAction func goCityVC(_ sender: Any) {
        let cityVC = CityVC(nibName: "\(CityVC.self)", bundle: nil)
        cityVC.delegate = self
        navigationController?.pushViewController(cityVC, animated: true)
    }

    @IBAction func addDidTapped() {
        CoreDataService.shared.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelDidTapped() {
        guard let result = viewModel.result else { return }
        CoreDataService.shared.managedObjectContext.delete(result)
        CoreDataService.shared.saveContext()
        dismiss(animated: true, completion: nil)
    }

    private func updateCurrent(){
        if let citys = viewModel.result?.city, let temp = viewModel.result?.current?.temp, let description = viewModel.result?.current?.attribute {
        self.nameCityLable.text = String(citys)
        self.temperatureLable.text = String(format: "%.1f°", temp)
        self.descriptionLable.text = description
        }
    }

    func bind(){
        viewModel.delegate = self
    }

    // MARK: - Lifecycle

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard viewModel.result != nil else { return 0 }
        return SectionDefault.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard viewModel.result != nil else { return 0 }
        switch section {
        case 0: return 1
        default: return viewModel.getDailyCount()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let result = viewModel.result else { return UICollectionViewCell() }
        updateCurrent()
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(type: HourlyViewCell.self, indexPath: indexPath)
            guard let hourly = result.hourly?.toArray(CurrentCoreData.self) else { return UICollectionViewCell() }
            let sortHourly = hourly.sorted{ $0.date < $1.date }
            cell.updateAll(hourlyArray: sortHourly)
            return cell

        default:
            let cell = collectionView.dequeueReusableCell(type: DailyViewCell.self, indexPath: indexPath)
            guard let daily = result.daily?.toArray(DailyCoreData.self) else { return UICollectionViewCell() }
            let sortDaily = daily.sorted{ $0.da < $1.da }
            cell.updateAll(daily: sortDaily[indexPath.row], indexPath: indexPath)
            return cell
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {
        case 0: return SectionDefault.size(forSection: .first)
        default: return SectionDefault.size(forSection: .secand)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SectionDefault.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return SectionDefault.edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(SectionHeader.self)", for: indexPath) as! SectionHeader
        switch indexPath.section {
        case 0:
            sectionHeader.configurateHeader(text: HeadersDefault.title(section: .first), headerImage: HeadersDefault.image(section: .first))
            return sectionHeader
        default:
            sectionHeader.configurateHeader(text: HeadersDefault.title(section: .secand), headerImage: HeadersDefault.image(section: .secand))
            return sectionHeader
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return HeadersDefault.size
    }

}


// MARK: - CityDelegate

extension MainVC: CityDelegate {

    func getCity(city: WeatherCoreData) {
        self.viewModel.result = city
    }
}

// MARK: - AlertHandler

extension MainVC: AlertHandler { }


extension MainVC: MainVCModelDelegate {
    func mainVCShowAllert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func mainVCCollectionViewReloadData() {
        collectionView.reloadData()
    }
}


extension MainVC: WeatherNibLoadable {}

