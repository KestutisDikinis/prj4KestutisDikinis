//
//  MapView.swift
//  prj4Navigation
//
//  Created by Niklas Thürnau on 13.05.21.
//

import SwiftUI
import MapKit
import UserNotifications

struct MapView: View {
    @EnvironmentObject var latestRoute: LatestRoute
    @EnvironmentObject var currentRouting: CurrentRouting
    @State var routeName: String = ""
    
    var body: some View {
        NavigationLink(
            destination: CreateRouteView(),
            label: {
                /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/
            })
    }
    
    func startRoute() -> Void {
        CreateRouteView()
    }
    
    func routeRoutine(routeName: String) -> Void {
        UNUserNotificationCenter.current()
            //2
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
              //3
              print("Permission granted: \(granted)")
            }

        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()

        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            
            var counter: Int = 0
            var position: Int = 1
            
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            var handler = HttpHandler()
            handler.createRoute( name: routeName,  latestRoute: latestRoute)
            
            handler.addRoutePoint(latestRoute: latestRoute, longitude: Float(locValue.longitude), latitude: Float(locValue.longitude), position: position)
            position = position+1
            counter = counter + 1
            sleep(30)
            while currentRouting.routingActive {
                handler.addRoutePoint(latestRoute: latestRoute, longitude: Float(locValue.longitude), latitude: Float(locValue.longitude), position: position)
                position = position+1
                counter = counter + 1
                if(counter == 60){
                    //do push notification
                    counter = 0
                }
                sleep(30)
            }
        }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
    
struct CreateRouteView : View {
    @State private var routeName: String = ""
    
    var body: some View{
        Text("")
        TextField("Name", text: $routeName)
        
        }
    }
}
