//
//  ViewController.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 3/26/17.
//  Copyright © 2017 bill. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDatabase
import UserNotifications

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, GMSAutocompleteFetcherDelegate, SearchResultsControllerDelegate, MessageViewControllerDelegate {
    
    var startupFlag = 0;
    var ref: FIRDatabaseReference!
    var curMarkers = Array<GMSMarker>()
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var markers =  Set<GMSMarker>()
    var userCreatedMarker: GMSMarker!
    
    var searchResultsController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {diAllow, error in
        })
        
        ref.observe(.value, with: { snapshot in
            print(snapshot.value ?? "error")
            
            if let dict = snapshot.value {
                self.mapView.clear()
                
                if let userMarker = self.userCreatedMarker {
                    userMarker.map = self.mapView
                }
                
                let messages = (dict as! NSDictionary).object(forKey: "messages") as! NSDictionary
                
                for key in messages.allKeys {
                    let message = messages.object(forKey: key) as! NSDictionary
                    
                    let lat_location = Double.init(message.object(forKey: "lat_location") as! CFloat)
                    let long_location = Double.init(message.object(forKey: "long_location") as! CFloat)
                    let coord = CLLocationCoordinate2D.init(latitude: lat_location, longitude: long_location)
                    
                    if (self.mapView.projection.contains(coord)){
                        
                        ServiceClient.sharedInstance().getMessageById(key as! String, completionHandlerForGetMessageByID: { (res, err) in
                            
                            if let error = err {
                                print("Error ", error )
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    let newMarker = CTMarker.init(id: key as! String, dictionary: res as! NSDictionary)
                                    newMarker.map = self.mapView
                                }
                            }
                        })
                    }
                }
            }
            
            if self.startupFlag != 0 {
                self.userNotificationConfig()
            }
            
        })
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.settings.compassButton = true;
        mapView.settings.myLocationButton = true;
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        loadMarkerData()
        drawMarker()
        
    }
    
    func loadMarkerData(){
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 10.764082, longitude: 106.682537)
        marker1.title = "KFC: on sale 20% for monday"
        marker1.snippet = "Gà không xương ăn sướng cả mồm"
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 10.761533, longitude: 106.682571)
        marker2.title = "Buồn"
        marker2.snippet = "Cần bạn trai thích màu tím nhưng không mộng mơ"
        
        markers.insert(marker1)
        markers.insert(marker2)
        
        searchResultsController = SearchResultsController()
        searchResultsController.delegate = self
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
    }
    
    func drawMarker(){
        for marker in markers{
            if marker.map == nil{
                marker.map = mapView
            }
        }
        
        
        if self.userCreatedMarker != nil && self.userCreatedMarker.map == nil {
            self.userCreatedMarker.map = mapView
            self.mapView.selectedMarker = self.userCreatedMarker
            
            //move camera to new marker
            let cameraUpdate = GMSCameraUpdate.setTarget(self.userCreatedMarker.position)
            mapView.animate(with: cameraUpdate)
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: CTMarker) -> UIView? {
        let inforWindow = UIView()
        
        inforWindow.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        inforWindow.backgroundColor = UIColor.gray
        
        let titleLabel = UILabel()
        let snippetLabel = UILabel()
        titleLabel.frame = CGRect(x: 14.0, y: 11.0, width: 175.0, height: 16.0)
        snippetLabel.frame = CGRect(x: 14.0, y: 42.0, width: 175.0, height: 16.0)
        snippetLabel.text = marker.snippet
        snippetLabel.textColor = UIColor.white
        titleLabel.text = marker.title
        titleLabel.textColor = UIColor.white
        inforWindow.addSubview(titleLabel)
        inforWindow.addSubview(snippetLabel)
        
        return inforWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        let alertView = UIAlertController.init(title: marker.title, message: marker.snippet, preferredStyle: UIAlertControllerStyle.alert)
//        
//        let actionButton = UIAlertAction.init(title: "Go", style: UIAlertActionStyle.default) { (action) in
//         //handle here
//        }
//        
//        alertView.addAction(actionButton)
//        self.present(alertView, animated: true, completion: nil)
        
        let messageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.position = marker.position
        messageViewController.userMarker = marker as! CTMarker
        messageViewController.delegate = self
   //     self.navigationController = UINavigationController.init()
        self.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let location = mapView.myLocation
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15)
        mapView.myLocation 
        mapView.animate(to: camera)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        //remove old marker which created last time
        if self.userCreatedMarker != nil{
            self.userCreatedMarker.map = nil
            self.userCreatedMarker = nil
        }
        
        //create new marker which located at touch position
        let userMarker = GMSMarker()
        
        userMarker.position = coordinate
        userMarker.appearAnimation = GMSMarkerAnimation.pop
        
        userMarker.title = "User marker"
        
        userMarker.map = nil
        
        self.userCreatedMarker = userMarker
        
        drawMarker()
    }
    
    func markerSent(marker: GMSMarker) {
        marker.map = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            
            // do whatever you want here with the location
            mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
            
            print("found location!")
            
        }
    }
    
    @IBAction func searchForLocation(_ sender: Any) {
        
        let searchController = UISearchController.init(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }

    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions{
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        
        self.searchResultsController.reloadDataWithArray(self.resultsArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        //do something :)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { 
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker.init(position: position)
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
            self.mapView.camera = camera
            
            marker.title = "Address: \(title)"
            marker.map = self.mapView
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        gmsFetcher.sourceTextHasChanged(searchText)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowMessageSegue"{
//            let messageVC = segue.destination as? MessageViewController
//            messageVC?.position = userCreatedMarker.position
//            
//        }
//    }
    
    func userNotificationConfig(){
        let content = UNMutableNotificationContent()
        content.title = "Location base sharing"
        content.subtitle = "new message is coming"
        content.body = "tap to se where it located"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


