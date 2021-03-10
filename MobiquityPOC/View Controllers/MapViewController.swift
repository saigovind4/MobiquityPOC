//
//  MapViewController.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 02/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goButton: UIButton!
    
    // MARK: - Search
    
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearch.Request!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearch.Response!
    
    // MARK: - Map variables
    
    fileprivate var annotation: MKAnnotation!
    fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    
    
    // MARK: - Activity Indicator
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    let newPin = MKPointAnnotation()
    private var cityname = ""
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gesture.delegate = self
        mapView.addGestureRecognizer(gesture)
        
        let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItem.Style.plain, target: self, action: #selector(currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.center = self.view.center
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if(CommonMethods.networkCheck()){
            if(cityname != ""){
                let trimmedCityName = cityname.replacingOccurrences(of: " ", with: "")
            ServiceClass.serviceClassObject.makeGETRequest(url: URLConstants.WeatherURLForCity(location: trimmedCityName), modelType: WeatherInfoModel.self, responseCallBack: self)
            } else {
                CommonMethods.ShowErrorAlert(message: AppConstants.invalidCity, vc: self)
            }
        } else {
            CommonMethods.ShowErrorAlert(message: AppConstants.noInternetMsg, vc: self)
        }
    }
    // MARK: - Actions
    
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem) {
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
    }
    
    // MARK: - Search
    
    @objc func searchButtonAction(_ button: UIBarButtonItem) {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alert = UIAlertController(title: nil, message: AppConstants.placeNotFound, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self!.present(alert, animated: true, completion: nil)
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            self!.cityname = pointAnnotation.title!
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        mapView.addAnnotation(pointAnnotation)
        pointAnnotation.title = getLocationInformation(lat: coordinate.latitude, long: coordinate.longitude, point: pointAnnotation)
        cityname = pointAnnotation.title!
    }
    
    private func getLocationInformation(lat: CLLocationDegrees, long: CLLocationDegrees, point: MKPointAnnotation)-> String
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude:  long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    self.cityname = city
                    point.title = self.cityname
                } else {
                    self.cityname = ""
                }
            }
        })
        return cityname
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isCurrentLocation {
            return
        }
        isCurrentLocation = false
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = getLocationInformation(lat: location!.coordinate.latitude, long: location!.coordinate.longitude, point: pointAnnotation)
        mapView.addAnnotation(pointAnnotation)
    }
    
}

 // MARK: - WebServiceProtocolDelegate

extension MapViewController: WebServiceProtocol
{
    func SuccessResponse(_ json: Codable) {
        DispatchQueue.main.async {
            self.goButton.isEnabled = true
        }
        if let jsonObj = json as? WeatherInfoModel {
            CoreDataHandler.coreDataHandlerObj.saveContextData(cityData: jsonObj)
            print("Success")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            DispatchQueue.main.async {
                CommonMethods.ShowErrorAlert(message: AppConstants.jsonParsingError, vc: self)
            }
        }
    }

    func ErrorResponse(_ error: NSError) {
        DispatchQueue.main.async {
            self.goButton.isEnabled = true
            CommonMethods.ShowErrorAlert(message: AppConstants.noDataError,vc: self)
        }
    }
    
    
}
