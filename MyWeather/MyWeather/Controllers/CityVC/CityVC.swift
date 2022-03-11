

import UIKit
import CoreLocation


final class CityVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.searchTextField.textColor = .white
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableViewRegistrCells()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var arrayOfBarButtons = [UIBarButtonItem]()
    var delegate: CityDelegate!                           
    var viewModel: CityViewModelProtocol = CityViewModel()

    // MARK: - Setups
    
    private func setupNavigationBarItem(){
        let onButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onButtonDidTapped))
        let ofButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ofButtonDidTapped))
        arrayOfBarButtons = [onButton, ofButton]
        navigationItem.setRightBarButton(onButton, animated: true)
    }

    private func tableViewRegistrCells(){
        tableView.register(Cell.defaultNib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }

    private func bind() {
        viewModel.delegate = self
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItem()
        bind()
    }
    
    // MARK: - funcs

    @objc func onButtonDidTapped(){
        navigationItem.setRightBarButton(arrayOfBarButtons[1], animated: false)
        tableView.setEditing(true, animated: true)
    }

    @objc func ofButtonDidTapped(){
        navigationItem.setRightBarButton(arrayOfBarButtons[0], animated: false)
        tableView.setEditing(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension CityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getResultCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(Cell.self)", for: indexPath) as! Cell
        cell.updateAll(weatherResponce: viewModel.result[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getCity(city: viewModel.result[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove city"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        CoreDataService.shared.managedObjectContext.delete(viewModel.result[indexPath.row])
        viewModel.result.remove(at: indexPath.row)
        CoreDataService.shared.saveContext()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
}


// MARK: - UISearchBarDelegate, UISearchDisplayDelegate

extension CityVC: UISearchBarDelegate, UISearchDisplayDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.sheskCity(city: searchBar.text)
    }
}


// MARK: - AlertHandler

extension CityVC: AlertHandler { }


extension CityVC: CityVCModelDelegate {
    func cityVCReloadData() {
        tableView.reloadData()
    }
    
    func cityVCShowAllert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func cityVCShowMainVC(city: String) {
        let mainVC = MainVC(nibName: "\(MainVC.self)", bundle: nil)
        mainVC.viewModel = MainViewModel(city: city)
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.navigationController?.present(mainVC, animated: true, completion: nil)
    }
}

