//
//  WeatherDetailViewController.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 08/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedCityTemperature: UILabel!
    @IBOutlet weak var selectedCityNameLabel: UILabel!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    
    // MARK: - variables

    var cityTemperate = ""
    var lattitude = ""
    var longitude = ""
    private  var weatherDetailInfo = WeatherDetailInfoModel()
    
    // MARK: - ViewDidLoad ViewWillAppear & DisappearDelegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCityTemperature.text = cityTemperate
        getWeatherForecastList()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: AppConstants.weatherDetailCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: AppConstants.weatherDetailCellName)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
       override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
           self.navigationController?.view.backgroundColor = .black
       }
       
       override func viewDidDisappear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = false
       }
    
    // MARK: - GetWeahterForcastListAPI
    private func getWeatherForecastList(){
        if(CommonMethods.networkCheck()){
            if(lattitude != ""  && longitude != "")
            {
                ServiceClass.serviceClassObject.makeGETRequest(url: URLConstants.WeatherForeCastListURLForCoordinates(lat: lattitude,long: longitude), modelType: WeatherDetailInfoModel.self, responseCallBack: self)
            } else{
                CommonMethods.ShowErrorAlert(message: AppConstants.noCoordinates, vc: self)
            }
        }else{
            CommonMethods.ShowErrorAlert(message: AppConstants.noInternetMsg, vc: self)
        }
    }
    
    // MARK: - formateDateFunction
    private func formatDateToShortType(dateStr: String)-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = AppConstants.dateFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        let date: Date? = dateFormatterGet.date(from: dateStr)
        let formattedData = dateFormatter.string(from: date!)
        return formattedData
    }

}

 // MARK: - UITableViewDelegates
extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(weatherDetailInfo.list != nil){
            count = weatherDetailInfo.list!.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"WeatherDetailCell") as! WeatherDetailCell
        if(weatherDetailInfo.list != nil){
            cell.dateDescLabel.text = formatDateToShortType(dateStr: weatherDetailInfo.list![indexPath.row].dtTxt)
            cell.weatherdescription.text = "\(weatherDetailInfo.list![indexPath.row].weather.first!.weatherDescription.capitalized)"
            cell.windvalueLabel.text = "\(weatherDetailInfo.list![indexPath.row].wind.speed)" + AppConstants.mph
            cell.tempMaxLabel.text = "\(weatherDetailInfo.list![indexPath.row].main.tempMax)"
            cell.tempMinLabel.text = "\(weatherDetailInfo.list![indexPath.row].main.tempMin)"
            cell.temperatureLabel.text = "\(weatherDetailInfo.list![indexPath.row].main.temp)" + AppConstants.degreeUnicode
            cell.humidityValue.text = "\(weatherDetailInfo.list![indexPath.row].main.humidity)" + AppConstants.percentageCode
            cell.cloudOrRainLabel.text = "\(weatherDetailInfo.list![indexPath.row].weather.first!.main.uppercased())"
            cell.cloudOrRainValueLabel.text = "\(weatherDetailInfo.list![indexPath.row].clouds.all)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

 // MARK: - WebServiceProtocolDelegate
extension WeatherDetailViewController: WebServiceProtocol
{
    func SuccessResponse(_ json: Codable) {
        if let jsonObj = json as? WeatherDetailInfoModel {
            weatherDetailInfo = jsonObj
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.selectedCityNameLabel.text = self.weatherDetailInfo.city?.name
                self.selectedCountryLabel.text = self.weatherDetailInfo.city?.country
            }
        }
    }
    
    func ErrorResponse(_ error: NSError) {
         DispatchQueue.main.async {
        CommonMethods.ShowErrorAlert(message: error.description,vc: self)
        }
    }    
    
}
