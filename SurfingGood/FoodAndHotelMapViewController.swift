//
//  FoodAndHotelMapViewController.swift
//  SurfingGood
//
//  Created by liusean on 25/06/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class FoodAndHotelMapViewController: UIViewController {

    @IBOutlet weak var foodAndHotelMapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = foodAndHotelMapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
//        foodAndHotelDataService.saveRestaurantInformation(restaurantName: "SurferInn 衝浪店", locationName: "宜蘭烏石港", type: "SufShop", latitude: 24.875806, longitude: 121.840245)
//        foodAndHotelDataService.saveRestaurantInformation(restaurantName: "福隆浪點", locationName: "東北角貢寮", type: "SurfSpot", latitude: 25.020785, longitude: 121.950421)
        
        foodAndHotelMapView.register(FoodAndHotelAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let initialLocation = CLLocation(latitude: 24.872123, longitude: 121.839492) // 烏石港
        
        self.centerMapOnlocation(location: initialLocation)
        
//        let seaFoodRestaurant = FoodAndHotel(title:"幸福36號", locationName:"宜蘭烏石港", discipline:"Food", coordinate:CLLocationCoordinate2D(latitude: 24.871169, longitude: 121.835919))
//        let petsHotel = FoodAndHotel(title:"布蘭奇頭城民宿", locationName:"宜蘭烏石港", discipline:"Hotel", coordinate:CLLocationCoordinate2D(latitude: 24.863403, longitude: 121.829239))
//        self.foodAndHotelMapView.addAnnotation(seaFoodRestaurant)
//        self.foodAndHotelMapView.addAnnotation(petsHotel)
        
        self.foodAndHotelMapView.delegate = self
        // Do any additional setup after loading the view.
        let restaurant:[FoodInformation] = foodAndHotelDataService.fetchRestaurantInformation()
        let context =  foodAndHotelDataService.context
        for element in restaurant {
//            context.delete(element);
            let seaFoodRestaurant = FoodAndHotel(title:element.restaurantName!, locationName:element.locationName!, discipline:element.type!, coordinate:CLLocationCoordinate2D(latitude: CLLocationDegrees(element.latitude), longitude: CLLocationDegrees(element.longitude)))
            self.foodAndHotelMapView.addAnnotation(seaFoodRestaurant)
//            print("restaurant name=\(element.restaurantName)")
//            print("location name=\(element.locationName)")
//            print("latitude=\(element.latitude)")
//            print("longitude=\(element.longitude)")
//            print("type=\(element.type)")
        }
        
        foodAndHotelMapView.isZoomEnabled = true
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnlocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius, self.regionRadius)
        foodAndHotelMapView.setRegion(coordinateRegion, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController: MKMapViewDelegate {
    
//    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? FoodAndHotel else { return nil }
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! FoodAndHotel
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

extension FoodAndHotelMapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        foodAndHotelMapView.removeAnnotations(foodAndHotelMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        foodAndHotelMapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        foodAndHotelMapView.setRegion(region, animated: true)
    }
}
