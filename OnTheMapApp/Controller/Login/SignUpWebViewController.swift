//
//  SignUpWebViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import UIKit
import WebKit

class SignUpWebViewController: UIViewController {

    // MARK: Properties


    // MARK: Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.startAnimating()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)



        let url = URL(string: "https://auth.udacity.com/sign-up")
        let request = URLRequest(url: url!)
        webView.load(request)




    }




}
