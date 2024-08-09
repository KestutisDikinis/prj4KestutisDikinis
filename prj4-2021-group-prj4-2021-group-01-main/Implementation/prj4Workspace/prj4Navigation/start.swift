//
//  start.swift
//  prj4Navigation
//
//  Created by Niklas Thürnau on 12.04.21.
//

import SwiftUI


struct start: View {
    @StateObject var profileInfo = ProfileDetails()
    @StateObject var latestRoute = LatestRoute()
    @StateObject var currentRouting = CurrentRouting()

    
    @State private var redirect = true
    
    var body: some View {
        VStack {
            NavigationView{
                VStack{
                    NavigationLink(
                        destination: LoginTest().navigationBarBackButtonHidden(true),
                        isActive: $redirect,
                        label: {
                            Text("")
                        })
                    }
            }
        }.environmentObject(profileInfo)
        .environmentObject(latestRoute)
        .environmentObject(currentRouting
        )
    }
}

// 4E64E1 blue
// 2E2B28 tint black
// EC4E20 jetRed
// F7F9FA tint white

struct start_Previews: PreviewProvider {
    static var previews: some View {
        start()
            .previewDisplayName("Test")
            
    }
}
