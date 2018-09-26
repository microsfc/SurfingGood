//
//  FoodMapViewController.swift
//  SurfingGood
//
//  Created by liusean on 13/06/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class FoodMapViewController: UIViewController, GMSMapViewDelegate {

    let infoMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 24.872123, longitude: 121.839492, zoom: 13.0)
        let mainMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mainMapView.settings.myLocationButton = true
        mainMapView.isMyLocationEnabled = true
        mainMapView.settings.scrollGestures = true
        mainMapView.settings.zoomGestures = true
        mainMapView.delegate = self
        view = mainMapView
        
        // Creates a marker in the center of the map.
        let foodMarker1 = GMSMarker()
        foodMarker1.position = CLLocationCoordinate2D(latitude: 24.871169, longitude: 121.835919)
        foodMarker1.title = "幸福36號海鮮餐廳"
        foodMarker1.snippet = "頭城"
        foodMarker1.map = mainMapView
        
        let foodMarker2 = GMSMarker()
        foodMarker2.position = CLLocationCoordinate2D(latitude: 24.864686, longitude: 121.828352)
        foodMarker2.title = "請上座美食熱炒"
        foodMarker2.snippet = "頭城"
        foodMarker2.map = mainMapView
        
        let hotelMarker1 = GMSMarker()
        hotelMarker1.position = CLLocationCoordinate2D(latitude: 24.863403, longitude: 121.829239)
        hotelMarker1.title = "布蘭奇頭城民宿"
        hotelMarker1.snippet = "頭城"
        hotelMarker1.map = mainMapView
    }
    
    // Attach an info window to the POI using the GMSMarker.
    func mapView(_ mapView:GMSMapView, didTapPOIWithPlaceID placeID:String,
                 name:String, location:CLLocationCoordinate2D) {
        infoMarker.snippet = placeID
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0;
        infoMarker.infoWindowAnchor.y = 1
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
