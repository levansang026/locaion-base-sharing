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

protocol MessageViewControllerDelegate {
    func markerSent(marker: GMSMarker)
}

class MessageViewController: UIViewController {

    var position: CLLocationCoordinate2D!
    var userMarker: CTMarker!
    var delegate: MessageViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var receiverLabel: UITextField!
    @IBOutlet weak var addFromButton: UIButton!
    @IBOutlet weak var privateMessageSwitch: UISwitch!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet var publicMessageSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //contentTextView.layer.cornerRadius = 5
        
        if let position = self.position{
            locationTextView.text = "Latitude: \(position.latitude)\nLongtitude: \(position.longitude)"
        }
        
        titleTextField.text = userMarker.title
        if let receiver = userMarker.receivers?.first {
            receiverLabel.text = receiver
            publicMessageSwitch.setOn(false, animated: false)
        } else {
            publicMessageSwitch.setOn(true, animated: false)
        }
        contentTextView.text = userMarker.snippet
    }

    @IBAction func addReceiverFromPressed(_ sender: Any) {
    }
    
    @IBAction func changeLocationBtnPressed(_ sender: Any) {
//        ServiceClient.sharedInstance().getMessageById(2) { (result, error) in
//            if let result = result{
//                NSLog("success")
//                print(result)
//            } else{
//                print("error: " + (error?.domain)!)
//            }
//        }
    }

    @IBAction func sendMessageBarBtnPressed(_ sender: Any) {
        
        let message = Message(sender: "admin@gmail.com", receiver: publicMessageSwitch.isOn ? "Public" : receiverLabel.text, position: position, title: titleTextField.text!, content: contentTextView.text!, createdDate: nil)
        
        ServiceClient.sharedInstance().sendNewMessage(message) { (result, error) in
            if let error = error{
                print("error: " + (error.domain))
            } else if let result = result{
                print(result)
            }
        }
        if let del = delegate {
            del.markerSent(marker: self.userMarker)
        }
        self.navigationController!.popViewController(animated: true)
    }
}
