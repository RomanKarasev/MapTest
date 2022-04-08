//
//  PlacesViews.swift
//  MapTest
//
//  Created by Роман Карасёв on 08.04.2022.
//

import Foundation
import MapKit

class PlacesMarkersView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let places = newValue as? Places else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = places.markerTintColor
            glyphImage = places.image
        }
    }
}

class PlacesView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let places = newValue as? Places else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            image = places.image
        }
    }
}

