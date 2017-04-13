
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
    
    func authenticateWithLoginViewController(_ email: String, _ password: String, _ completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        
        self.getRequestToken(email, password) { (success, requestToken, error) in
            
            if success {
                
                self.getUserId(requestToken!, { (success, userID, error) in
                    
                    if success {
                        //store userID in session
                        
                        let preferences = UserDefaults.standard
                        preferences.set(userID, forKey: "session")
                        
                        completionHandlerForAuth(success, error)
                    } else {
                        completionHandlerForAuth(success, error)
                    }
                })
            } else {
                completionHandlerForAuth(success, error)
            }
        }
        
    }
    
    func getRequestToken(_ email: String, _ password: String, _ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void){
        
        
        let jsonBody = "{\"email\": \"\(email)\", \"password\": \"\(password)\"}"
        
        let _ = taskForPostMethod("/auth_api/login", parameters: [:], jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Login fail (Request Token)")
            } else if let requestToken = results?["token"] as? String{
                completionHandlerForToken(true, requestToken, nil)
            } else {
                print("Could not find token in results")
                completionHandlerForToken(false, nil, "Login fail (Request Token)")
            }
            
        }
    }
    
    func getUserId(_ requestToken: String, _ completionHandlerForGetUserID: @escaping (_ success: Bool, _ userID: String?, _ errorString: String?) -> Void){
    
        let _ = taskForGetMethod("/auth_api/profile", parameters: [:], requestToken) { (results, error) in
            
            if let error = error {
                print("\(error)")
                completionHandlerForGetUserID(false, nil, "Login fail (User ID")
            } else if let userID = results?["_id"] as? String{
                completionHandlerForGetUserID(true, userID, nil)
            } else {
                print("Could not file user id in results")
                completionHandlerForGetUserID(false, nil, "Login fail (User ID")
            }
        }
    }
}
