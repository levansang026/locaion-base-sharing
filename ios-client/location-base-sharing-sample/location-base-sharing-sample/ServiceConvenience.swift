
//
//  authenticateWithLoginViewController.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 4/12/17.
//  Copyright © 2017 bill. All rights reserved.
//

import Foundation
import UIKit

extension ServiceClient{
    
    func authenticateWithLoginViewController(){
        
    }
    
    func getRequestToken(_ hostViewController: UIViewController, _ identifierString: String, _ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void){
        
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let email = 
        
        let parameters = [String: AnyObject]()
        
        let jsonBody = "{\"email\": \"\()"
        
        let _ taskForPostMethod("/auth_api/login", parameters: <#T##[String : AnyObject]#>, jsonBody: <#T##String#>, completionHandlerForPost: <#T##(AnyObject?, NSError?) -> Void#>)    }
}
