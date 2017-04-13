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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        //task for get user data
  
        
        
        if let email = emailTextField.text {
            
            if let password = passwordTextField.text {
                ServiceClient.sharedInstance().authenticateWithLoginViewController(email, password, { (success, error) in
                    
                    if success {
                        print("Login successful")
                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! ViewController
                        
                        self.present(mainVC, animated: true, completion: nil)
                    } else {
                        print("Login fail with error: \(error)")
                    }
                })
            }
            
        }
        
        
    }
    
    @IBAction func facebookLoginBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func googleLoginBtnPressed(_ sender: Any) {
    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        self.present(registerVC, animated: true, completion: nil)
    }
    
}
