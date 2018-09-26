//
//  FoodAndHotel.swift
//  SurfingGood
//
//  Created by liusean on 25/06/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class FoodAndHotel: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placeMark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        return mapItem
    }
    
    var markerTintColor: UIColor  {
        switch discipline {
//        case "美食":
//            return .red
//        case "Mural":
//            return .cyan
        case "Hotel":
            return .yellow
        case "Food":
            return .purple
        case "SufShop":
            return .orange
        case "SurfSpot":
            return .blue
        default:
            return .green
        }
    }
    
    var imageName: String? {
        if discipline == "Food" { return "" }
        switch discipline {
        case "Food":
            return "fastfood"
        case "Hotel":
            return "hotel"
        case "SufShop":
            return "surfShop"
        case "SurfSpot":
            return "wave"
        default:
            return "fastfood"
        }
    }
    
}
