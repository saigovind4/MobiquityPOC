//
//  WebServiceProtocol.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 07/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import Foundation
 protocol WebServiceProtocol
{
    func SuccessResponse(_ json : Codable)
    
    func ErrorResponse(_ error : NSError)
}
