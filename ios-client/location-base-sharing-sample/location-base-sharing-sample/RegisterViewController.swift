//
//  RegisterViewController.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 4/13/17.
//  Copyright © 2017 bill. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func isReadyToRegister() -> Bool {
        
        if emailTextField.text != "" {
            if nameTextField.text != "" {
                if (passwordTextField.text?.characters.count)! >= 6 {
                    if passwordIsMatched() {
                        return true
                    }
                }
            }
        }
        
        return false
        
    }
    
    func passwordIsMatched() -> Bool {
        if passwordTextField.text == confirmPassword.text{
            return true
        }
        
        return false
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        if isReadyToRegister(){
            
            //ServiceClient.sharedInstance().
            
        } else {
            print("please check text fields")
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
    }
    
}
