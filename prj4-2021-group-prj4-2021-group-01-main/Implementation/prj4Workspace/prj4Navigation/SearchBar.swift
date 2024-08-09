//
//  SearchBar.swift
//  prj4Navigation
//
//  Created by Julia Sartori on 19.05.21.
//

import Foundation
import SwiftUI
import UIKit
import MapKit
import CoreLocation
import Combine


class SearchBar: NSObject, ObservableObject{
    
    enum LocationStatus: Equatable {
           case idle
           case noResults
           case isSearching
           case error(String)
           case result
       }
    

    
    
       @Published var queryFragment: String = ""
       @Published private(set) var status: LocationStatus = .idle
       @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
       
       private var queryCancellable: AnyCancellable?
       private let searchCompleter: MKLocalSearchCompleter!
       var matchingItems: [MKMapItem] = []
       var mapView: MKMapView?
    
    
       init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
           self.searchCompleter = searchCompleter
           super.init()
           self.searchCompleter.delegate = self
        
        //subscribing to changes to the queryFragment String field wich is connected to TextField in Navi. If it changes we are getting updated
         queryCancellable = $queryFragment
               .receive(on: DispatchQueue.main)
               // we're debouncing the search, because the search completer is rate limited.
               // this makes sure we are initializing the search only after a specific delay. this way we only search when there is a substential string input by the user but we can also react to typos
               .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
               .sink(receiveValue: { fragment in
                   self.status = .isSearching
                   if !fragment.isEmpty {
                       self.searchCompleter.queryFragment = fragment
                   } else {
                       self.status = .idle
                       self.searchResults = []
                   }
           })
       }
   }
   

//MKLocalSearchCompleter uses delegate pattern -> set delegate for search completer and implement MKLocalSearchCompleterDelegate protocol
    extension SearchBar: MKLocalSearchCompleterDelegate {
       func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
           /* Filter still needs work. Filtering for an empty Subtitle apparently seems to filter out a lot of places and only shows cities and countries. Make sure you search for cities / countries near you
               Find out how far MKLocalSearch reaches */
           self.searchResults = completer.results.filter({ $0.subtitle == "" })
           self.status = completer.results.isEmpty ? .noResults : .result
       }
       
       func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
           self.status = .error(error.localizedDescription)
       }
   }
   

extension SearchBar: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchCompleter = searchController.searchBar.text
         else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchCompleter
        request.region = mapView.region
        let search = MKLocalSearch(request: request)

        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.mapView?.reloadInputViews()
        }
        
    }

func updateSearchResultsForSearchController(searchController: UISearchController) {
// No need to update anything if we're being dismissed.
if !searchController.isActive {
       return
   }
   // you can access the text in the search bar as below
   //filterString = searchController.searchBar.text

guard let mapView = mapView,
    let searchBarText = searchController.searchBar.text else { return }

let request = MKLocalSearch.Request()
request.naturalLanguageQuery = searchBarText
request.region = mapView.region
let search = MKLocalSearch(request: request)

search.start { response, _ in
    guard let response = response else {
        return
    }
    self.matchingItems = response.mapItems
    //self.tableView.reloadData()
 }
}
    
    func parseAddress(selectedItem:MKPlacemark) -> String {

        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
                            selectedItem.thoroughfare != nil) ? " " : ""

        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""

        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                            selectedItem.administrativeArea != nil) ? " " : ""

        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )

        return addressLine
      }}

//extension SearchBar: UITableViewDelegate{
//
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItems.count
//    }
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let selectedItem = matchingItems[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
//        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//        return cell
//     }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let selectedItem = matchingItems[indexPath.row].placemark
//        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
//        //dismiss(animated: true, completion: nil)
//    }
//
//      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//               let selectedItem = matchingItems[indexPath.row].placemark
//               cell.textLabel?.text = selectedItem.name
//               let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
//       cell.detailTextLabel?.text = address
//               return cell
//           }
//
//       func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//            let selectedItem = matchingItems[indexPath.row].placemark
//           handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
//         //dismiss(animated: true, completion: nil)
//        }
//    }



//struct SearchBarModifier: ViewModifier {
//
//    let searchBar: SearchBar
//
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                ViewControllerResolver { viewController in
//                    viewController.navigationItem.SearchController = self.searchBar.searchController
//                }
//                    .frame(width: 0, height: 0)
//            )
//    }
//}



//extension View {
//    
//    func add(_ searchBar: SearchBar) -> some View {
//        return self.modifier(SearchBarModifier(searchBar: searchBar))
//    }
// }

 
 


