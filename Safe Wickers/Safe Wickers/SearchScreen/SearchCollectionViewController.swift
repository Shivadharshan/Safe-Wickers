//
//  SearchCollectionViewController.swift
//  Safe Wickers
//
//  Created by 匡正 on 17/4/20.
//  Copyright © 2020 匡正. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func createSearchLocation(placemark:MKPlacemark)
}

private let reuseIdentifier = "activityCell"
private var sectionInsets = UIEdgeInsets()
private let itemsPerRow: CGFloat = 3


class SearchCollectionViewController: UIViewController, UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate
{
    
    @IBOutlet weak var searchNavigationItem: UINavigationItem!
    
    @IBOutlet weak var locationLabel: UILabel!
    
   
    @IBOutlet weak var locationTextField: UITextField!
    
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    
    @IBAction func showSearchBar(_ sender: Any) {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        let searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController.searchResultsUpdater = locationSearchTable
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for location or beach"
       
        present(searchController,animated: true,completion: nil)
        
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    var selectedLocation: MKPlacemark?
    
    var activities = [Activities]()
    var activityName: String?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var searchLocation: CLLocationCoordinate2D?
    var currentLocation: CLLocationCoordinate2D?
    var currentLocationName: String?
    
// add logo image to navigationbar
    func addNavBarImage() {
        let navController = navigationController!
        navigationController?.navigationBar.barTintColor = UIColor(red:0.27, green:0.45, blue:0.58, alpha:1)
        let image = UIImage(named: "titleLogo.png")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationTextField.placeholder = "Search or Use current location"
        addNavBarImage()
     
        createDefaultActivities()
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self

        sectionInsets = UIEdgeInsets(top: 5.0, left: 6.0, bottom: 5.0, right: view.bounds.width/30)

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        locationManager.delegate = self


      
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location.coordinate
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//     func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let activityCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        let activty = activities[indexPath.row]
        
        activityCell.activityImageView.image = UIImage(named: activty.imageName!)
                //?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            activityCell.activityNameLabel.text = activty.activityName
    
        // Configure the cell
    
        return activityCell
    }


    // highlight or not when tap
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let activityCell = collectionView.cellForItem(at: indexPath){
            activityCell.contentView.backgroundColor = #colorLiteral(red: 0.073441759, green: 0.7529120877, blue: 1, alpha: 0.7747217466)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }

    /// - Tag: selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionViewCell {
            cell.contentView.backgroundColor = UIColor.gray
            activityName = activities[indexPath.row].activityName
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionViewCell {
            cell.contentView.backgroundColor = nil
        }
    }
    
    
// custom the layout of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //return activityCollectionView.frame.width/20
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layoutcollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt
        section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    

    /*
     Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    @IBAction func currentLocationButton(_ sender: Any) {
        if let currentLocation = currentLocation{
            searchLocation = currentLocation
            reverseGeocode()
            
    }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
    }

    }
    
    
    
    @IBAction func searchButton(_ sender: Any) {
        if searchLocation == nil {
            let alertController = UIAlertController(title: "Location Missing", message: "Location missing, try to search a location or use current location.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else if activityName == nil {
            let alertController = UIAlertController(title: "Actvity Missing", message: "Location missing, try to chose an activity.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else{
            performSegue(withIdentifier: "ShowBeachList", sender: self)
        }
    }
    
    
    
    func createDefaultActivities(){
        activities.append(Activities(imageName: "icons8-swimmer-96.png", activityName: "Swimming"))
        activities.append(Activities(imageName: "icons8-surf-96.png", activityName: "Surfing"))
        activities.append(Activities(imageName: "icons8-row-boat-96.png", activityName: "Boating"))
    }
    
    // from Coordinate to location name, ref: https://www.cnblogs.com/Free-Thinker/p/4843578.html
    func reverseGeocode(){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude),
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                let searchLocationName = (firstLocation?.subLocality)! + ", " + (firstLocation?.locality)!
                                                self.currentLocationName = searchLocationName
                                                self.locationTextField.text = searchLocationName
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                              self.locationTextField.text = "Cannot show the location name"
                                              print("error in reverse Decode process")
                                            }
        })

    }
    
//    // from location name to Coordinate , ref: https://www.cnblogs.com/Free-Thinker/p/4843578.html
//    func locationEncode(){
//        let geocoder = CLGeocoder()
//        if self.locationTextField.text != nil {
//            geocoder.geocodeAddressString(self.locationTextField.text!, completionHandler: {
//                (placemarks, error) in
//                if error != nil{
//                    let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                }
//
//                let firstplace = placemarks?[0]
//                self.searchLocation = firstplace?.location?.coordinate
//            })
//        }
//
//    }

    
    //configure the location auto complete textField ref:
    
//    func ACTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    return true
//}
    
    
    
//    //Data sources for location atuo compele textField
//    fileprivate func vicSuburbs() -> [String] {
//        if let path = Bundle.main.path(forResource: "victoria_suburb_names", ofType: "json")        {
//            do {
//                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
//                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:String]]
//
//                var suburbNames = [String]()
//                for suburb in jsonResult {
//                    suburbNames.append(suburb["name"]!)
//                }
//
//                return suburbNames
//            } catch {
//                print("Error parsing jSON: \(error)")
//                return []
//            }
//        }
//        return []
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBeachList"{
            let destination = segue.destination as! BeachListTableViewController
            destination.regionLocation = searchLocation
            destination.activityName = self.activityName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchCollectionViewController: HandleMapSearch {
    func createSearchLocation(placemark:MKPlacemark){
        // cache the pin
        
        selectedLocation = placemark
        
        
        if placemark.locality != nil && placemark.administrativeArea != nil {
            self.searchLocation = placemark.coordinate
            self.locationTextField.text = placemark.locality! + ", " + placemark.administrativeArea!
        } else {
            self.locationTextField.text = ""
            self.searchLocation = nil
            let alertController = UIAlertController(title: "Wrong Location", message: "The location has not yet been determined, try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
}

