//
//  LoginViewController.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 4/12/17.
//  Copyright © 2017 bill. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let prefrences = UserDefaults.standard
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        //task for get user data
        
    }
    
    @IBAction func facebookLoginBtnPressed(_ sender: Any) {
    }
    
    @IBAction func googleLoginBtnPressed(_ sender: Any) {
    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
    }
    
}
