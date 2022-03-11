

import Foundation
import CoreData
import CoreLocation

// MARK: - CityViewModelProtocol

protocol CityViewModelProtocol: NSObject {
    
    var result: [WeatherCoreData] { get set }
    var showAllert: ((_: String , _: String) -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var showMainVC: ((_: String) -> Void)? { get set }
    func sheskCity(city: String?) -> Void
}


final class CityViewModel: NSObject,CityViewModelProtocol {
    
    // MARK: - Properties
    
    private var networcManager = NetworkManager()
    private var fetchedResultsController: NSFetchedResultsController<WeatherCoreData>!
    var showAllert: ((_: String , _: String) -> Void)?
    var showMainVC: ((String) -> Void)?
    var reloadData: (() -> Void)?
    
    var result: [WeatherCoreData] = [] {
        didSet { reloadData?() }
    }
    
    // MARK: - Setups
    
    fileprivate func setupFetchController() {
        let request = NSFetchRequest<WeatherCoreData>(entityName: "WeatherCoreData")
        let firstSortedDescription = NSSortDescriptor(key: "active", ascending: false)
        let secandSortedDescription = NSSortDescriptor(key: "city", ascending: false)
        request.sortDescriptors = [firstSortedDescription, secandSortedDescription]
        fetchedResultsController = NSFetchedResultsController<WeatherCoreData>(fetchRequest: request, managedObjectContext: CoreDataService.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
    }
    
    // MARK: - funcs
    
    func sheskCity(city: String?) {
        guard let city = city else { return }
        CLGeocoder().geocodeAddressString(city) { [weak self] (placeMarc, error) in
            guard let searchCity = placeMarc?.first?.locality else {
                self?.showAllert?("Sorry", "City error")
                return
            }
            
            let bool = self?.result.contains { $0.city == searchCity }
            guard let bool = bool, !bool else {
                self?.showAllert?("Sorry", "You have \(searchCity) in your list")
                return
            }
            
            self?.showMainVC?(searchCity)
        }
    }
    
    private func loadWeatherCoreData(){
        try? fetchedResultsController.performFetch()
        if let result = fetchedResultsController.fetchedObjects {
            self.result = result
        }
    }
    
    private func updateModels(){
          self.result.forEach { model in
              guard let city = model.city else { return }
              networcManager.fetchWeatherWithCity(sity: city) { response, error in
                  guard let response = response else { return }
                  CoreDataService.shared.managedObjectContext.delete(model)
                  response.createCoreDataWeather(active: model.active, complition: nil)
              }
          }
        CoreDataService.shared.saveContext()
        loadWeatherCoreData()
      }

    // MARK: - Override Init
    
    override init() {
        super.init()
        setupFetchController()
        loadWeatherCoreData()
        updateModels()
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension CityViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadWeatherCoreData()
    }
}

