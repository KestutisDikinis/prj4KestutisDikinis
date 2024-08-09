

import SwiftUI
import UIKit
import MapKit

/*Tab view for prj4
 Does not need to reload pages
 each time pages switch
*/

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Home : View {
    
    @State var selectedTab = "Home"
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @Namespace var animation
    @StateObject var modelData = ModelView()
    @ObservedObject private var handler = HttpHandler()
    @EnvironmentObject var profileDetails: ProfileDetails
    @State private var showingDetail = false

    var body: some View{
        
        VStack(){
            
            GeometryReader{_ in
                
                ZStack{
                    Text("Rankings")
                    .opacity(selectedTab == "Rankings" ? 1 : 0)
                    
                    Navi()
                        .opacity(selectedTab == "Navigation" ? 1 : 0)
                    
                    Profile()
                        .opacity(selectedTab == "Profile" ? 1 : 0)
                }
            }
            .onChange(of: selectedTab) { (_) in
                
                switch(selectedTab){
                
                case "Rankings": if !modelData.isRankingsLoad{modelData.loadRankings()}
                case "Navigation": if !modelData.isNavigationLoad{modelData.loadNavigation()}
                case "Profile": if !modelData.isProfileLoad{modelData.loadProfile()}
                default: ()
                }
            }
            
            // TabView...
            
            HStack(spacing: 0){
                
                ForEach(tabs,id: \.self){tab in
                    
                    TabButton(title: tab, selectedTab: $selectedTab,animation: animation)
                    if tab != tabs.last{
                        Spacer(minLength: 0)
                        
                    }
                }
            }
            .padding(.horizontal,30)
            .padding(.bottom,edges!.bottom == 0 ? 15 : edges!.bottom)
            .background(Color.white)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
}

// Tab Button...

struct TabButton : View {
    
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    
    var body: some View{
        
        Button(action: {
            withAnimation{selectedTab = title}
        }) {
            
            VStack(spacing: 6){
                
                ZStack{}.padding(.bottom,0)
                
                Image(title)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(selectedTab == title ? Color(red: 78/255, green: 100/255, blue: 225/255) : Color(red: 236/255, green: 78/255, blue: 32/255).opacity(0.2))
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 78/255, green: 100/255, blue: 225/255).opacity(selectedTab == title ? 0.6 : 0.2))
            }
        }
    }
}


// Both Title Image Name Are Same....
var tabs = ["Home","Rankings","Navigation","Profile"]

//This is used for loading tab only once, not to overload the phone

class ModelView : ObservableObject{
    
    @Published var isNavigationLoad = false
    @Published var isRankingsLoad = false
    @Published var isProfileLoad = false
    init() {
        
        // load initial data
        print("Home Loaded")
    }
    
    func loadNavigation(){
        
        print("navigation Loaded")
        isNavigationLoad = true
    }
    
    func loadRankings(){
        
        print("rankings Loaded")
        isRankingsLoad = true
    }
    
    func loadProfile(){
        print("profile Loaded")
        isProfileLoad = true
    }
}
