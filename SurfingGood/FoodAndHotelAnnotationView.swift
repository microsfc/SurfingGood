//
//  FoodAndHotelAnnotationView.swift
//  SurfingGood
//
//  Created by liusean on 28/06/2018.
//  Copyright © 2018 liusean. All rights reserved.
//

import UIKit
import MapKit

class FoodAndHotelAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let foodOrHotel = newValue as? FoodAndHotel else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "route"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            markerTintColor = foodOrHotel.markerTintColor
//            glyphText = String(foodOrHotel.discipline.first!)
            if let imageName = foodOrHotel.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
