//
//  MapView.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 30.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViewContainer: View {
    @ObservedObject var mapdata: MapFetcher = MapFetcher()
    @State var showWarning: Bool = false
    
    func getAnnotations() -> [FriendAnnotation] {
        var annotations: [FriendAnnotation] = []
        for item in mapdata.mapitems {
            if(item.value.lat != 0.0 && item.value.lng != 0.0 && item.value.acc < 200.0) {
                annotations.append(FriendAnnotation(title: item.key, coordinate: .init(latitude: item.value.lat, longitude: item.value.lng), pass: item.value.pass))
            }
            
        }
        return annotations
    }
    
    var body: some View {
        let showWarningBinding = Binding<Bool>(get: {
            return self.mapdata.showError
        }, set: {
            self.showWarning = $0
        })
        
        return ZStack {
            VStack {
                Button(
                    action: { self.mapdata.load()},
                    label: { Text(self.mapdata.connectBtn)
                        .font(.footnote)
                        .multilineTextAlignment(.trailing)
                        .padding(.all, 10.0)
                        .shadow(color: Color.black, radius: 10, x: 0, y: 10)
                        .background(Color.white)
                        .cornerRadius(10.0)
                    }
                )
                    .frame(width: UIScreen.main.bounds.width-45.0, height: 60, alignment: .topTrailing)
                    .padding(.top, 10.0)
                Spacer()
            }
            .zIndex(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
            MapView(mapdata: self.getAnnotations())
        }.alert(isPresented: showWarningBinding) {
            Alert(title: Text("Couldn't fetch position data. Did you enable webgpsmap?"))
        }
    }
}

struct MapView: UIViewRepresentable {
    var mapdata: [FriendAnnotation]
    //Model with test data
    
    
    /**
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
    func makeUIView(context: Context) -> MKMapView{
        return MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        print("Map updating")
        view.delegate = context.coordinator
        view.removeAnnotations(mapdata)
        view.addAnnotations(mapdata)
        
    }
    
    func makeCoordinator() -> MapViewCoordinator{
        MapViewCoordinator(self)
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        var mapViewController: MapView
        
        init(_ control: MapView) {
            self.mapViewController = control
        }
        
        func mapView(_ mapView: MKMapView, viewFor
            annotation: MKAnnotation) -> MKAnnotationView?{
            //Custom View for Annotation
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "customView")
            annotationView.canShowCallout = true
            if(annotation.subtitle == "Pass unknown") {
                annotationView.pinTintColor = UIColor.red
            } else {
                annotationView.pinTintColor = UIColor.green
            }
            
            return annotationView
        }
    }
    
}

class FriendAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let pass: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, pass: String?) {
        self.title = title
        if(pass != nil) {
            self.subtitle = "Pass: \(pass!)"
        } else {
            self.subtitle = "Pass unknown"
        }
        self.coordinate = coordinate
        self.pass = pass
    }
}


//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
