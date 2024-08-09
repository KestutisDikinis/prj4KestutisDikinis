//
//  Navi.swift
//  prj4Navigation
//
//  Created by Julia Sartori on 14.04.21.
//

import Foundation
import SwiftUI
import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

struct Navi: View{
    
    @State var region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 48.0235129, longitude: 11.0891474), latitudinalMeters: 10000, longitudinalMeters: 10000)
   @State var tracking : MapUserTrackingMode = .follow
   @State var manager = CLLocationManager()
    
      
      @ObservedObject var searchBar: SearchBar = SearchBar()


    var body : some View{
    NavigationView {
        VStack {
                    Form {
                        Section(header: Text("Search")) {
                            ZStack(alignment: .trailing) {
                                TextField("Search", text: $searchBar.queryFragment)
                                // This is optional and simply displays an icon during an active search
                                 if searchBar.status == .isSearching {
                                     Image(systemName: "clock")
                                         .foregroundColor(Color.gray)
                                }
                            }
                        }
                        Section(header: Text("Results")) {
                            List {
                                
                                Group { () -> AnyView in
                                    switch searchBar.status {
                                    case .noResults: return AnyView(Text("No Results"))
                                    case .error(let description): return AnyView(Text("Error: \(description)"))
                                    default: return AnyView(EmptyView())
                                    }
                                }.foregroundColor(Color.gray)
                                
                                ForEach(searchBar.searchResults, id: \.self) { completionResult in
                                     //This just lists the results, use a Button to perform an action or use a NavigationLink to move to the next view upon selection
                                    Button(action:  {
                                            //add what the button should do here
                                    }){                               Text(completionResult.title)
                                    }
                                }
                            }
                        }
                    }
                }
        ZStack{
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking)
        }
            }
        
    NavigationView {
                ZStack{
                    Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking)
                }
                        .navigationBarTitle("", displayMode: .inline)
//                        .add(self.searchBar)
                }
            }

   }

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, HandleMapSearch, UISearchBarDelegate{
    
    func transition() {
    let mapVC:ViewController = ViewController()
    let navigationController = UINavigationController(rootViewController: mapVC)
    navigationController.modalPresentationStyle = .fullScreen
    self.present(navigationController, animated: true, completion: nil)
    }
    
    
    //not used right now, for custom searches
    func dropPinZoomIn(placemark: MKPlacemark) {
        func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    }
    
    var selectedPin: MKPlacemark?
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        
        //Should show the users location, gets latitude and longitude
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    @objc func getDirections(){
            guard let selectedPin = selectedPin else { return }
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
          }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
    
 
 
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }

      
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: (error)")
        }
   

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{

                guard !(annotation is MKUserLocation) else { return nil }
                let reuseId = "pin"
                var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
                if pinView == nil {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                }
                pinView?.pinTintColor = UIColor.orange
                pinView?.canShowCallout = true
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "car"), for: .normal)
                button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
                pinView?.leftCalloutAccessoryView = button

                return pinView
            }
}
    


extension ViewController: UISearchResultsUpdating {
func updateSearchResults(for searchController: UISearchController) {
print("Do something here, such as get the searchBar's text and execute a search.")
}
}

struct Navi_Previews: PreviewProvider {
        static var previews: some View {
            Navi()
            }
    }






    


