//
//  ViewController.swift
//  MapTest
//
//  Created by Роман Карасёв on 07.04.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    
    private var places: [Places] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 59.929691, longitude: 30.362239)
        mapView.centerLocation(initialLocation)
        
        
        let cameraCenter = CLLocation(latitude: 59.929691, longitude: 30.362239)
        let region = MKCoordinateRegion(center: cameraCenter.coordinate,
                                        latitudinalMeters: 50000,
                                        longitudinalMeters: 50000)
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRage = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        mapView.setCameraZoomRange(zoomRage, animated: true)
        
        let KC = Places(title: "Казанский собор",
                        locationName: "Казанская пл. 2",
                        discipline: "Cathedral",
                        coordinate: CLLocationCoordinate2D(latitude: 59.934257, longitude: 30.324495))

        mapView.addAnnotation(KC)
        
        loadInitialData()
        mapView.addAnnotations(places)
    }
    
    private func loadInitialData() {
       
        guard
                let fileName = Bundle.main.url(forResource: "Places", withExtension: "geojson"),
                let placesData = try? Data(contentsOf: fileName)
        else {
            return
        }
        
        do {
            
            let features = try MKGeoJSONDecoder()
                .decode(placesData)
                .compactMap { $0 as? MKGeoJSONFeature}
            
            let validWorks = features.compactMap(Places.init)
            places.append(contentsOf: validWorks)
            
        } catch {
            print("\(error)")
            
        }
        
    }
}

extension MKMapView {
    func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Places else {
            return nil
        }
        
        let identifier = "places"
        let view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "places") as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let places = view.annotation as? Places else {
            return
        }
        
        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        places.mapItem?.openInMaps(launchOptions: launchOption)
        
    }
}
