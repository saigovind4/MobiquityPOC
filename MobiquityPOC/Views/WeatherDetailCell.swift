//
//  WeatherDetailCell.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 08/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import UIKit

class WeatherDetailCell: UITableViewCell {

    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherdescription: UILabel!
    @IBOutlet weak var windvalueLabel: UILabel!
    @IBOutlet weak var cloudOrRainLabel: UILabel!
    @IBOutlet weak var cloudOrRainValueLabel: UILabel!
    @IBOutlet weak var dateDescLabel: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
