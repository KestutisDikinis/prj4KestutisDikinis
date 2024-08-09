//
//  Profile.swift
//  prj4Navigation
//
//  Created by Marek Broz on 4/14/21.
//

import SwiftUI



//container view that shows all the content
struct Profile: View {
    
    //editingIsOn state bool variable for changing profile information
    //selection variable for which page is selected
    @State var selection:Int = 0
    @State var editingIsOn = false
    //booleans for modifying the button background color
    @State var profileSelected = false
    @State var routesSelected = false
    @State var pointsSelected = false
    
    //set variables for the colour palette
    @State var blue = Color(hex: 0x4E64E1)
    @State var jetRed = Color(hex: 0x4E64E1)
    @State var tintBlack = Color(hex: 0x2E2B28)
    @State var tintWhite = Color(hex: 0xF7F9FA)
    //boolean to toggle the circle scaling animation.
    @State var onTop = false
    
    //states for the point count image animations
    @State var starsGroup1Moving = false
    @State var starsGroup2Moving = false
    @State var smallStar1Pop = false
    @State var smallStar2Pop = false
    // variables for the point count animation
    @State private var percent: CGFloat = 0
    @State private var totalPoints: CGFloat = 14355
    //variables for editing profile
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var city = ""
    
    //to instanciated the environment object, handle - send and receive responses from httpRequests
    @ObservedObject private var handler = HttpHandler()
    @EnvironmentObject var profileDetails: ProfileDetails
    //for profile picture
    //showCaptureImageView   - View opens to select the image
    //inEditingPicture - when true, the save button
    @State var showCaptureImageView: Bool = false
    @State var image: String = ""
    @State var inEditingPicture = false
    
    var body: some View {
        
        //Vertical container that holds all elements
        VStack{
            //show base image if profilePic is empty
            if(profileDetails.profilePic == ""){
                Image("cyclingapp")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.top, 30)
                .frame(alignment: .center)
                .shadow(radius: 10.0, x: 20, y: 10)
            }
            if(profileDetails.profilePic != ""){
                Image(uiImage: UIImage(data: Data(base64Encoded: profileDetails.profilePic)!)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.top, 30)
                .frame(alignment: .center);
            }
            
            //button to toggle the image picker window
            Button(action: {
                self.showCaptureImageView.toggle()
                inEditingPicture = true
            
            }){
                Text("Chose pic")
            }
            //assigns the image when selected to image var
            if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image)
            }
            //submits the image and turns off the editing picture mode when finished
            if(inEditingPicture == true){
                
                Button(action:{
                    handler.uploadPictureToDb(image: image, profileDetails: profileDetails, callback: {inEditingPicture = false})
                }){
                    Text("Save")
                }
            }
            Text(profileDetails.username)
                .font(.system(size: 21, weight: .medium, design: .default))
                .frame(alignment: .center);
                
            Text(profileDetails.city)
                .font(.system(size: 15, design: .default))
                .frame(alignment: .center);
            
            //to swipe to not visible nav.bar sections
            ScrollView(.horizontal){
                HStack{
                    //button to navigate the user to the route history section
                    Button(action: {
                        print("Profile Information")
                        selection = 1
                        isPointsSelected()
                    }) {
                        Text("Profile Information")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .offset(y: 0)
                    .buttonStyle(MyButtonStyle())
                    
                    Button(action: {
                        selection = 2
                        isPointsSelected()
                    }) {
                        Text("Route History")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .buttonStyle(MyButtonStyle())
                    
                    Button(action: {
                        selection = 3
                        isPointsSelected()
                    }) {
                        Text("Points")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    //buttonstyle for looks
                    .buttonStyle(MyButtonStyle())
                    Spacer()
                }
                //for the nav buttons to have more padding from the left
                .padding(.leading)
            }
            
        
            
            //for swiping between pages functionality
            if(!editingIsOn){
            ZStack{
                VStack{
                    //PLACEHOLDER FOR selection parameter for the nav bar to select the correct page
                    TabView(selection: $selection){
                        //Embedded form for styling the HStacks
                        //Profile info section
                        Form {
                            //Added sections for spacing between other sections and naming groups

                            Section(header: Text("PROFILE INFORMATION")){
                                HStack{
                                    Text("First Name")
                                    Spacer()
                                    Text(profileDetails.firstName)
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                HStack{
                                    Text("Last Name")
                                    Spacer()
                                    Text(profileDetails.lastName)
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                HStack{
                                    Text("Email")
                                    Spacer()
                                    Text(profileDetails.email)
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                HStack{
                                    Text("City")
                                    Spacer()
                                    Text(profileDetails.city)
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                HStack{
                                    Text("Birthday")
                                    Spacer()
                                    Text(profileDetails.birthday)
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                            }
                            Section{
                                //Added action button for user to interact with
                                Button(action:  {
                                        editingIsOn = true
                                }) {Text("Edit Profile Information")
                                }
                                
                            }
                        }
                        //tags
                        .tag(1)
                        //History group
                        Form {
                            //Section name
                            Section(header: Text("ROUTES HISTORY")){
                                //Spacing between each route entry
                                HStack{
                                    Image("route")
                                        .resizable()
                                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                        .cornerRadius(10)
                                    VStack(alignment: .leading){
                                        Text("Limburg hidden gems")
                                            .font(.system(size: 18, weight: .medium, design: .default))
                                            .offset(y:5)
                                        Text("148.8km")
                                            .offset(y:20)
                                        Text("21.2.2021")
                                            .offset(x:175)
                                    }
                                }
                                HStack{
                                    Image("route")
                                        .resizable()
                                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                        .cornerRadius(10)
                                    VStack(alignment: .leading){
                                        Text("Explore Eindhoven")
                                            .font(.system(size: 18, weight: .medium, design: .default))
                                            .offset(y:5)
                                        Text("47.1km")
                                            .offset(y:20)
                                        Text("14.5.2021")
                                            .offset(x:175)
                                    }
                                }
                                HStack{
                                    Image("route")
                                        .resizable()
                                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                        .cornerRadius(10)
                                    VStack(alignment: .leading){
                                        Text("Wonder Forest")
                                            .font(.system(size: 18, weight: .medium, design: .default))
                                            .offset(y:5)
                                        Text("68.2km")
                                            .offset(y:20)
                                        Text("21.2.2021")
                                            .offset(x:175)
                                    }
                                }
                            }
                        }
                        .tag(2)
                        
                        //Points group
                        Form {
                            //Images that create the main point count container
                            ZStack(){
                                Image("StarBckg8")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .scaleEffect(2.8)
                                    .offset(x: 0, y: -38)
                                //circle with the total points counter
                                Circle()
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .foregroundColor(blue)
                                    .modifier(AnimatingNumberOverlay(number: percent))
                                
                                    .onAppear(){
                                        withAnimation(Animation.easeInOut(duration: 5)){
                                            percent = totalPoints
                                        }
                                    }
                                
                                Image("Star2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 140,alignment: .center)
                                    .rotationEffect(.degrees(starsGroup1Moving ? -5 : 15))
                                    .animation(Animation.linear(duration: 1.4)
                                    .repeatForever(autoreverses: true))
                                    //starts animation when image is visible
                                    .onAppear(){
                                        self.starsGroup1Moving.toggle()
                                    }
                                    .offset(x: -105, y: -50)
                                
                                Image("Star3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 110, height: 110,alignment: .center)
                                    //.rotationEffect(Angle(degrees: -10))
                                    
                                    .rotationEffect(.degrees(starsGroup2Moving ? -5 : 20))
                                    .animation(Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: true))
                                    .onAppear(){
                                        self.starsGroup2Moving.toggle()
                                    }
                                    .offset(x: 50, y: 70)
                                
                                Image("Stars4")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40,alignment: .center)
                                    .offset(x: 85, y: -78)
                                
                                Image("Stars4")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40,alignment: .center)
                                    .rotationEffect(Angle(degrees: -80))
                                    .offset(x: -75, y: 55)
                                
                                Image("Star5")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20,alignment: .center)
                                    .scaleEffect(smallStar1Pop ? 1.0 : 1.2)
                                    .animation(Animation.easeIn(duration: 1).repeatForever())
                                    .onAppear(){
                                        self.smallStar1Pop.toggle()
                                    }
                                    .offset(x: -138, y: -107)
                                
                                Image("Star7")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20,alignment: .center)
                                    .scaleEffect(smallStar2Pop ? 1.0 : 1.2)
                                    .animation(Animation.easeIn(duration: 1).repeatForever())
                                    .onAppear(){
                                        self.smallStar2Pop.toggle()
                                    }
                                    .offset(x: 105, y: 50)
                            }
                            .offset(x: 80)
                            
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150, alignment: .center)
                            .padding(.vertical, 50)
                            
                            //Sections
                            Section(header: Text("Cycling")){
                                //Spacing between each route entry
                                
                                    HStack{
                                        Text("Completed routes")
                                        Spacer()
                                        Text("3")
                                            .foregroundColor(.gray)
                                            .font(.callout)
                                    }
                                    HStack{
                                        Text("Distance traveled")
                                        Spacer()
                                        Text("34673")
                                            .foregroundColor(.gray)
                                            .font(.callout)
                                    }
                            }
                            Section(header: Text("Activity")){
                                HStack{
                                    Text("Posted reviews")
                                    Spacer()
                                    Text("975")
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                                HStack{
                                    Text("Created routes")
                                    Spacer()
                                    Text("7224")
                                        .foregroundColor(.gray)
                                        .font(.callout)
                                }
                            }
                            }
                        .tag(3)
                    }
                    //enables you to swipe
                    .tabViewStyle(PageTabViewStyle())
                }
            }
        }
            //forms that show up when you are editing your profile information
            if(editingIsOn == true){
                Form {
                    //Added sections for spacing between other sections and naming groups

                    Section(header: Text("PROFILE INFORMATION")){
                        HStack{
                            Text("First Name")
                            Spacer()
                            TextField(profileDetails.firstName, text: $profileDetails.firstName)
                                .foregroundColor(.gray)
                                .font(.callout)
                        }
                        HStack{
                            Text("Last Name")
                            Spacer()
                            TextField(profileDetails.lastName, text: $profileDetails.lastName)
                                .foregroundColor(.gray)
                                .font(.callout)
                        }
                        HStack{
                            Text("Email")
                            Spacer()
                            TextField(profileDetails.email, text: $profileDetails.email)
                                .foregroundColor(.gray)
                                .font(.callout)
                                
                        }
                        HStack{
                            Text("City")
                            Spacer()
                            TextField(profileDetails.city, text: $profileDetails.city)
                                .foregroundColor(.gray)
                                .font(.callout)
                        }
                    }
                    Section{
                        //Added action button for user to submit or cancel their prof. info changes
                        Button(action:  {
                            handler.editProfile(profileDetails: profileDetails, callback: {editingIsOn = false})
                        }) {Text("Submit")
                        }
                        Button(action:  {
                                editingIsOn = false
                        }) {Text("Cancel")
                        }
                        
                    }
                }
            }
            //hides the top nav bar
        }.navigationBarHidden(true)
    }
   //function to initiate the circle animation once the button is pressed
    func isPointsSelected(){
        if (selection == 3){
            self.onTop = true
        }
    }
}



//extension for letting us import our own hex colour values
// 4E64E1 blue
// 2E2B28 tint black
// EC4E20 jetRed
// F7F9FA tint white
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

//styling configuration for the nav buttons that are applied
struct MyButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding(5)
      
      .foregroundColor(.blue)
        .background(configuration.isPressed ? Color(hex: 0x2E2B28) : Color.white)
      .cornerRadius(10.0)
  }
}

//for the points number counter
//gradual number animation from 0 to the value
struct AnimatingNumberOverlay : AnimatableModifier {
    var number: CGFloat
    var animatableData: CGFloat{
        get {
            number
        }
        
        set {
            number = newValue
        }
    }
    
    //styling
    func body(content: Content) -> some View {
        return
            content.overlay(Text("\(Int (number))").font(.title).fontWeight(.bold))
    }
}


//Renders the code in a preview window
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Profile()
        }
    }
}

//LEFTOVERS FROM TESTING LEFT FOR LATER POSSIBLE USAGE
extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
