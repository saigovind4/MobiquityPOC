//
//  ServiceClass.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 07/03/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import Foundation
class ServiceClass {
    
    static let serviceClassObject = ServiceClass()
    
    private init(){}
    
    internal func makeGETRequest <T: Codable> (url: String, modelType: T.Type, responseCallBack: WebServiceProtocol) {
        let restURL = URL(string: url)
        URLSession.shared.dataTask(with: restURL!) { (data, response , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(modelType, from: data)
                responseCallBack.SuccessResponse(jsonData)
            } catch let err {
                responseCallBack.ErrorResponse(err as NSError)
                print("Err", err)
            }
        }.resume()
    }
    
    
}
