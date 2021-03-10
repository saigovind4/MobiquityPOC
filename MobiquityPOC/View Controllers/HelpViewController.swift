//
//  ViewController.swift
//  MobiquityPOC
//
//  Created by Bhonsle, Sai (Cognizant) on 25/02/21.
//  Copyright © 2021 Sai Govind. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "help", withExtension: "html"){
            webView.loadFileURL(url, allowingReadAccessTo: url)
            let request = URLRequest(url: url as URL)
            webView.load(request)
        }
    }
}

