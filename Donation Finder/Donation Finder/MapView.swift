//
//  MapView.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/11/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct MapViewRep: UIViewRepresentable {
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        print("Making MKMapView")
        viewModel.mapView.delegate = context.coordinator
        viewModel.mapView.showsUserLocation = true
        viewModel.mapView.showsCompass = false
        viewModel.mapView.showsScale = true
        
        viewModel.mapView.register(DonationLocationMarkerView.self, forAnnotationViewWithReuseIdentifier: "marker")
        viewModel.mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: "cluster")
        
        context.coordinator.followUserIfPossible()
        dataModel.filterAnnotationArray()
        viewModel.mapView.addAnnotations(dataModel.donationLocations)
        
        return viewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        print("DonationLocation count: =\(dataModel.donationLocations.count)")
        print("DonationLocation count: =\(uiView.annotations.count)")
                
        /// uiView.annotations array is "-1" because it contains the MKUserLocation in it as well
        if dataModel.donationLocations.count != uiView.annotations.count - 1 {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(dataModel.donationLocations)
            print("Annotations Updated: count=\(dataModel.donationLocations.count)")
        }
        
        if viewModel.isAnnotationSelected == true {
            viewModel.mapView.deselectAnnotation(dataModel.donationLocation, animated: true)
            viewModel.isAnnotationSelected = false
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        return Coordinator(self, dataModel: dataModel, viewModel: viewModel)
    }
    
    
    
    
    
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var mapViewRep: MapViewRep
        var dataModel: DataModel
        var viewModel: ViewModel
        let locationManager = CLLocationManager()
        
        init(_ mapViewRep: MapViewRep, dataModel: DataModel, viewModel: ViewModel) {
            self.mapViewRep = mapViewRep
            self.dataModel = dataModel
            self.viewModel = viewModel
            super.init()
            setupLocationManager()
        }
        
        fileprivate func setupLocationManager() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.pausesLocationUpdatesAutomatically = true
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        func followUserIfPossible() {
            print("\(type(of: self)).\(#function)\n", terminator: "")
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self.viewModel.mapView.setUserTrackingMode(.follow, animated: true)
            default:
                break
            }
        }
        
        
        
        
        // MARK: MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            if let marker = annotation as? DonationLocation {
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? DonationLocationMarkerView
                if view == nil {
                    view = DonationLocationMarkerView(annotation: marker, reuseIdentifier: "marker")
                }
                return view

            } else if let cluster = annotation as? MKClusterAnnotation {
                var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? ClusterView
                if view == nil {
                    view = ClusterView(annotation: cluster, reuseIdentifier: "cluster")
                }
                return view
            }

            return nil
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            print("\(type(of: self)).\(#function)\n", terminator: "")
            if viewModel.detailsCardPosition == .hidden {
                mapView.deselectAnnotation(dataModel.donationLocation, animated: true)
            }
        }
        
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("\(type(of: self)).\(#function): view= \(view)\n", terminator: "")
            
            // Zooms in if a cluster is selected
            if (view.annotation is MKClusterAnnotation) {
                print(mapView.camera.centerCoordinateDistance)
                
                guard let clusterCoordinate = view.annotation?.coordinate else { return }
                let radius = mapView.camera.centerCoordinateDistance
                let regionRadius = CLLocationDistance(floatLiteral: radius / 2)
                var span: MKCoordinateSpan = viewModel.mapView.region.span
                var coordinateRegion = MKCoordinateRegion(center: clusterCoordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                
                // delta is the zoom factor, 2 will zoom out x2, .5 will zoom in by x2
                span.latitudeDelta *= 0.5
                span.longitudeDelta *= 0.5
                coordinateRegion.span = span
                viewModel.mapView.setRegion(coordinateRegion, animated: true)
            }
            
            // Handle what to do when an annotation is selected
            if let donationLocation = view.annotation as? DonationLocation {
                self.viewModel.mapView.setUserTrackingMode(.none, animated: true)
                viewModel.detailsCardPosition = .middle_lower
                dataModel.donationLocation = donationLocation
                moveCenter(mapView, byOffset: CGPoint(x: 0, y: 100), from: donationLocation.coordinate)
            }
        }
        
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            print("\(type(of: self)).\(#function): view= \(view)\n", terminator: "")
            viewModel.detailsCardPosition = .hidden
        }
        
        
        private func moveCenter(_ mapView: MKMapView, byOffset offset: CGPoint, from coordinate: CLLocationCoordinate2D) {
            print("\(type(of: self)).\(#function): offset= \(offset)\n", terminator: "")
            var point = mapView.convert(coordinate, toPointTo: mapView)
            point.x += offset.x
            point.y += offset.y
            let center = mapView.convert(point, toCoordinateFrom: mapView)
                mapView.setCenter(center, animated: true)
        }
        
        
        
        
        // MARK: CLLocationManagerDelegate
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print("\(type(of: self)).\(#function): status= \(status)\n", terminator: "")
            checkLocation(status: status)
        }
        
        private func checkLocation(status: CLAuthorizationStatus) {
            print("\(type(of: self)).\(#function): status= \(status)\n", terminator: "")
            switch status {
            case .restricted:
                // Possibly due to active restrictions such as parental controls being in place
                print(".restricted")
                viewModel.mapView.setUserTrackingMode(.none, animated: true)
                viewModel.showMapAlertRestricted.toggle()
                break
            case .denied:
                print(".denied")
                viewModel.mapView.setUserTrackingMode(.none, animated: true)
                viewModel.showMapAlertDenied.toggle()
                return
            case .notDetermined:
                print(".notDetermined")
                self.locationManager.requestWhenInUseAuthorization()
                return
            case .authorizedWhenInUse:
                print(".authorizedWhenInUse")
                self.locationManager.startUpdatingLocation()
                self.viewModel.mapView.setUserTrackingMode(.follow, animated: true)
                return
            case .authorizedAlways:
                print(".authorizedAlways")
                self.locationManager.startUpdatingLocation()
                viewModel.mapView.setUserTrackingMode(.follow, animated: true)
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.pausesLocationUpdatesAutomatically = false
                return
            @unknown default:
                print("@unknown")
                break
            }
        }
        
        
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewRep()
    }
}


