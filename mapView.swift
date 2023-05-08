//  mapView.swift
//  FoodPin
//
//  Created by alumno on 17/04/23.
//

import SwiftUI
import MapKit

struct mapView: View {
    var location: String = ""
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773),
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    @State private var annotatedItems: [AnnotatedItem] = [
        AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773)),
        AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.511357, longitude: -0.115773)),
        AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 51.509357, longitude: -0.118773))
    ]
    
    private func convertAddress(location: String){
        let geoCoder=CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: {placemarks, error in
            /////pcional
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,
                  let location = placemarks[0].location else {
                return
            }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            self.annotatedItems = [
                AnnotatedItem(coordinate: location.coordinate),
                AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.001, longitude: location.coordinate.longitude)),
                AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.001, longitude: location.coordinate.longitude))
            ]
        })
    }
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
    }
    
    var body: some View {
        VStack {
            Text("Store Locations")
                .font(.title)
                .bold()
            
            Map(coordinateRegion: $region, annotationItems: annotatedItems) { item in
                MapMarker(coordinate: item.coordinate, tint: .purple)
            }
            .task {
                convertAddress(location: location)
            }
        }
    }
}


struct mapView_Previews: PreviewProvider {
    static var previews: some View {
        mapView(location: "costco")
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

struct Previews_mapView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
