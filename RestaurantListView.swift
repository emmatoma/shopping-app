import SwiftUI
struct RestaurantListView: View {
    var restaurantNames = RestaurantConstants.restaurantNames
    var restaurantImages = RestaurantConstants.restaurantImages
    var restaurantLocations = RestaurantConstants.restaurantLocations
    var restaurantTypes = RestaurantConstants.restaurantTypes
    var productDetails = RestaurantConstants.productDetails
    @State var restaurantIsFavorites = Array(repeating: false, count: 21)
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemPink)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Women's Essentials")
                        .font(.system(size: 24, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    List {
                        ForEach(restaurantNames.indices, id: \.self) { index in
                            NavigationLink(
                                destination: RestaurantDetailView(restaurantIsFavorites:$restaurantIsFavorites[index],
                                                                  name: restaurantNames[index],
                                                                  imageName: restaurantImages[index],
                                                                  type: restaurantTypes[index],
                                                                  location: restaurantLocations[index],
                                                                  productDetails:productDetails[index]
                                                                  
                                                                  )
                            ) {
                                FullImageRow(isFavorite: $restaurantIsFavorites[index],
                                             imageName: restaurantImages[index],
                                             name: restaurantNames[index],
                                             type: restaurantTypes[index],
                                             location: restaurantLocations[index])
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button(action: {
                                            restaurantIsFavorites[index].toggle()
                                        }) {
                                            Image(systemName: restaurantIsFavorites[index] ? "heart.fill" : "heart")
                                        }
                                        .tint(.pink)
                                        Button(action: {
                                            restaurantIsFavorites[index].toggle()
                                        }) {
                                            Image(systemName:  "bookmark")
                                        }
                                        .tint(.black)
                                        Button(action: {
                                            restaurantIsFavorites[index].toggle()
                                        }) {
                                            Image(systemName:  "cart.badge.plus")
                                                
                                        }
                                        .tint(.blue)
                                        
                                    }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    ///////acaba la lista
                    .listStyle(.plain)
                    .padding(.top, 20)
                    /////pestañas
                    TabView(selection: $selectedTab) {
                        NavigationLink(destination: UserInfoView()) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        .tag(0)

                        NavigationLink(destination: mapView()) {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 80)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
enum NavigationDestination {
    case reviewView
}

struct FullImageRow: View {
    @State private var showOptions = false
    @State private var showError = false
    @State private var showReviewView = false
    @State private var navigationSelection: NavigationDestination? = nil
    @Binding var isFavorite: Bool
    
    var imageName: String
    var name: String
    var type: String
    var location: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                    
                    Text(type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                if isFavorite {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            
        }
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Add to cart")
                    Image(systemName: "cart")
                }
            }
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Save")
                    Image(systemName: "bookmark")
                }
            }
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text(self.isFavorite ? "Unmark as Favorite" : "Mark as favorite")
                    Image(systemName: self.isFavorite ? "heart.slash" : "heart")
                }
            }
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text("Rate product")
                    Image(systemName: "star")
                }
            }
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .onTapGesture {
            showOptions.toggle()
        }
        .actionSheet(isPresented: $showOptions) {
            ActionSheet(title: Text("ACTIONS"),
                        message: nil,
                        buttons: [
                            .default(Text("Add to cart")) {
                                self.showError.toggle()
                            },
                            .default(Text("Add to wishlist")) {
                                self.showError.toggle()
                            },
                            .default(Text("See sizes")) {
                                self.showError.toggle()
                            },
                            .default(Text(self.isFavorite ? "Unmark as favorite" : "Mark as favorite")) {
                                self.isFavorite.toggle()
                            },
                            .default(Text("Rate product")) {
                                self.showOptions.toggle()
                                self.navigationSelection = NavigationDestination.reviewView
                            },
                            .default(Text("Share")) {
                                self.showError.toggle()
                            },
                            .cancel()
                        ]
            )
        }
        .background(
            NavigationLink(destination: ReviewView(name: name), tag: NavigationDestination.reviewView, selection: $navigationSelection) {
                EmptyView()
            }
        )
        .alert(isPresented: $showError) {
            Alert(title: Text("Not yet available"),
                  message: Text("Sorry, this feature is not yet available. Please try again later."),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .cancel()
            )
        }
        
    }
}


    struct BasicTextImageRow: View {
        var imageName: String
        var name: String
        var type: String
        var location: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 20) {
                Image(imageName)
                    .resizable()
                    .frame(width: 120, height: 118)
                    .cornerRadius(20)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.title2, design: .rounded))
                    
                    Text(type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            RestaurantListView()
                .previewDisplayName("Women's Essentials")
                .background(Color(red: 255/255, green: 221/255, blue: 238/255))
                .navigationTitle("Women's Essentials")
            
            RestaurantListView()
                .previewDisplayName("Dark Side")
                .preferredColorScheme(.dark)
                .background(Color(red: 255/255, green: 221/255, blue: 238/255))
                .navigationTitle("Women's Essentials")
        }
    }

