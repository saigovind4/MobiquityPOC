//
//  HomeViewController.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 04/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var citybookmarksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    fileprivate var cities: [NSManagedObject] = []
    fileprivate var filteredArray : [NSManagedObject] = []
    fileprivate var searchActive : Bool = false
    
    // MARK: - ViewDidLoad ViewWillAppear & DisappearDelegates
    override func viewDidLoad() {
        super.viewDidLoad()
        citybookmarksTableView.delegate = self
        citybookmarksTableView.dataSource = self
        let nib = UINib(nibName: AppConstants.customTableCellName, bundle: nil)
        citybookmarksTableView.register(nib, forCellReuseIdentifier: AppConstants.customTableCellName)
        self.citybookmarksTableView.estimatedRowHeight = 50
        self.citybookmarksTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecordsFromCoreData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - GetsRecordsFromCoreData
    fileprivate func fetchRecordsFromCoreData()
    {
        cities = CoreDataHandler.coreDataHandlerObj.fetchAllData()
        citybookmarksTableView.reloadData()
    }
    
    // MARK: - AddLocationButtonTapHandler
    @IBAction func addlocationButtonTapped(_ sender: UIButton) {
        let mapVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        self.navigationController?.pushViewController(mapVC!, animated: true)
    }
    
}

// MARK: - UITableViewDelegates
extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredArray.count : cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = citybookmarksTableView.dequeueReusableCell(withIdentifier:AppConstants.customTableCellName) as! CustomTableViewCell
        if(searchActive) {
            let filteredCities = filteredArray[indexPath.row]
            cell.mainTitleLabel.text = filteredCities.value(forKeyPath: AppConstants.coreDataCity) as? String
            cell.subTitleLabel.text = filteredCities.value(forKeyPath: AppConstants.coreDatamaindescription) as? String
            cell.temperatureLabel.text = filteredCities.value(forKeyPath: AppConstants.coreDataTemp) as? String
            
        } else{
            let city = cities[indexPath.row]
            cell.mainTitleLabel.text = city.value(forKeyPath: AppConstants.coreDataCity) as? String
            cell.subTitleLabel.text = city.value(forKeyPath: AppConstants.coreDatamaindescription) as? String
            cell.temperatureLabel.text = city.value(forKeyPath: AppConstants.coreDataTemp) as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetailsVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController
        if(searchActive) {
            weatherDetailsVC?.lattitude = filteredArray[indexPath.row].value(forKeyPath: AppConstants.coreDataLat) as! String
            weatherDetailsVC?.longitude = filteredArray[indexPath.row].value(forKeyPath: AppConstants.coreDataLong) as! String
            weatherDetailsVC?.cityTemperate = filteredArray[indexPath.row].value(forKeyPath: AppConstants.coreDataTemp) as! String
        } else {
            weatherDetailsVC?.lattitude = cities[indexPath.row].value(forKeyPath: AppConstants.coreDataLat) as! String
            weatherDetailsVC?.longitude = cities[indexPath.row].value(forKeyPath: AppConstants.coreDataLong) as! String
            weatherDetailsVC?.cityTemperate = cities[indexPath.row].value(forKeyPath: AppConstants.coreDataTemp) as! String
        }
        navigationController?.pushViewController(weatherDetailsVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var objectToDelete : NSManagedObject!
            if(searchActive) {
                objectToDelete = filteredArray[indexPath.row]
            } else {
                objectToDelete = cities[indexPath.row]
            }
            if (CoreDataHandler.coreDataHandlerObj.deleteRecord(object: objectToDelete))
            {
                if(searchActive) {
                    filteredArray.remove(at: indexPath.row)
                } else {
                    cities.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                fetchRecordsFromCoreData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = cities.filter({
            let name = $0.value(forKey: AppConstants.coreDataCity) as? String
            return name?.range(of: searchBar.text!, options: .caseInsensitive) != nil
        })
        if(filteredArray.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        citybookmarksTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        filteredArray.removeAll()
        citybookmarksTableView.reloadData()
        self.view.endEditing(true)
    }
}
