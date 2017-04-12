//
//  MessageViewController.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 3/28/17.
//  Copyright © 2017 bill. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MessageViewController: UIViewController {

    var position: CLLocationCoordinate2D!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var receiverLabel: UITextField!
    @IBOutlet weak var addFromButton: UIButton!
    @IBOutlet weak var privateMessageSwitch: UISwitch!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //contentTextView.layer.cornerRadius = 5
        
        if let position = self.position{
            locationTextView.text = "Latitude: \(position.latitude)\nLongtitude: \(position.longitude)"
        }
        
    }

    @IBAction func addReceiverFromPressed(_ sender: Any) {
    }
    
    @IBAction func changeLocationBtnPressed(_ sender: Any) {
        ServiceClient.sharedInstance().getMessageById(2) { (result, error) in
            if let result = result{
                NSLog("success")
                print(result)
            } else{
                print("error: " + (error?.domain)!)
            }
        }
    }

    @IBAction func sendMessageBarBtnPressed(_ sender: Any) {
        let message = Message(sender: "adming@gmail.com", receiver: nil, position: position, title: "Volka CA SAU", content: "cam xuc khong chi tot hon", createdDate: nil)
        ServiceClient.sharedInstance().sendNewMessage(message) { (result, error) in
            if let error = error{
                print("error: " + (error.domain))
            } else if let result = result{
                print(result)
            }
        }
    }
}
