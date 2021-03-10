//
//  CommonMethods.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 07/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import Foundation
import UIKit

class CommonMethods {
    
    internal static func networkCheck() -> Bool {
        var networkStatus = false
        let reachability = Reachability()!
        if reachability.isReachable {
            networkStatus = true
        } else {
            networkStatus = false
        }
        return networkStatus
    }
    
    internal static func ShowErrorAlert(message: String, vc: UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
