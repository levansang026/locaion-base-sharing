//
//  ServiceClient.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 3/28/17.
//  Copyright © 2017 bill. All rights reserved.
//

import Foundation

class ServiceClient : NSObject{
    
    class func sharedInstance() -> ServiceClient{
        struct Singleton{
            static var sharedInstance = ServiceClient()
        }
        return Singleton.sharedInstance
    }
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    //task for CRUD methods:
    
    //GET
    func taskForGetMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError? ) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: serviceURLFromParameters(parameters, withPathExtension: method))
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else{
                print("there was error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                print("Your request returned a status code others than 2xx")
                return
            }
            print (statusCode)
            
            guard let data = data else{
                print("No data found with your request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        task.resume()
        return task
        
    }
    
    func taskForGetMethod(_ method: String, parameters: [String: AnyObject], _ requestToken: String, completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError? ) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: serviceURLFromParameters(parameters, withPathExtension: method))
        
        request.addValue("Bearer " + requestToken, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else{
                print("there was error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                print("Your request returned a status code others than 2xx")
                return
            }
            
            guard let data = data else{
                print("No data found with your request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        task.resume()
        return task
    }

    
    
    func getMessageById(_ messageID: String, completionHandlerForGetMessageByID: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let method = substituteKeyInMethod(ServiceClient.Method.MessagesByID, key: "id", value: String(messageID))
        
        let _ = taskForGetMethod(method!, parameters: [:]) { (result, error) in
            if let error = error {
                completionHandlerForGetMessageByID(nil, error)
            } else {
                if let result = result{
                    completionHandlerForGetMessageByID(result, error)
                } else {
                    completionHandlerForGetMessageByID(nil, NSError(domain: "taskForGetMessageByID", code: 1, userInfo: [NSLocalizedDescriptionKey: "could not parse data"]))
                }
            }
        }
        
    }
    
    //POST
    func taskForPostMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String ,
                                   completionHandlerForPost: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        //build url and configure request
        
        let request = NSMutableURLRequest(url: serviceURLFromParameters(parameters, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        //Make request:
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                print("Your request returned a status code others than 2xx")
                return
            }
            
            guard let data = data else{
                print("No data returned by your request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        task.resume()
        
        return task
    }
    
    func sendNewMessage(_ message: Message,_ completionHandlerForAddNewMessage: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
        
        
        //init json vody
        let jsonBody = "{\"title\": \"\(message.title)\",\"content\": \"\(message.content)\", \"lat_location\": \(message.position.latitude), \"long_location\": \(message.position.longitude), \"sender\": \"\(message.sender)\"}"
        
        //Make the request
        let _ = taskForPostMethod("/api/messages", parameters: [:], jsonBody: jsonBody) { (result, error) in
            if let error = error{
                completionHandlerForAddNewMessage(nil, error)
            } else {
                if let result = result {
                    completionHandlerForAddNewMessage(result, nil)
                } else {
                    completionHandlerForAddNewMessage(nil, NSError(domain: "sendNewMessage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse respone"]))
                }
            }
        }
    }
    
    //Helper
    private func serviceURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL{
        
        var components = URLComponents()
        var res: URL!
        
        components.scheme = ServiceClient.ServiceConst.scheme
        components.host = ServiceClient.ServiceConst.host
        components.path = (withPathExtension ?? "")
        if parameters.count > 0{
            components.queryItems = [URLQueryItem]()
        }
        
        for (key, value) in parameters{
            let queryItem = URLQueryItem.init(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        res = components.url
        
        if (components.host?.contains(":"))! {
            var tempStr = components.url?.absoluteString
            tempStr = tempStr?.replacingOccurrences(of: "%3A", with: ":")
            res = URL.init(string: tempStr!)
            
        }
        
        return res
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {

        var parsedResult: AnyObject! = nil
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    
}
