import SwiftUI
struct RestaurantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var restaurantIsFavorites: Bool
    var name: String
    var imageName: String
    var type: String
    var location: String
    var productDetails: String
    var body: some View {
        ZStack(alignment: .top) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    Color.black
                        .opacity(0.8)
                        .cornerRadius(20)
                        .padding()
                        .frame(height: geometry.size.height * 0.7)
                        .overlay {
                            VStack(spacing: 5) {
                                
                                Image(systemName: restaurantIsFavorites ? "heart.fill" : "heart")
                                    .foregroundColor(restaurantIsFavorites ? .white : .gray)
                                    .onTapGesture {
                                        restaurantIsFavorites.toggle()
                                    }
                                
                                Text(name)
                                    .font(.custom("Cardo-Regular", size: 30))
                                HStack(alignment: .center) {
                                    if RestaurantConstants.ratings[name, default: 0] == 0 {
                                        Text("no reviews")
                                            .font(.custom("Cardo-Regular", size: 12))
                                    } else {
                                        ForEach(1...RestaurantConstants.ratings[name, default: 1], id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.pink)
                                        }
                                    }
                                }
                                Text(type)
                                    .font(.custom("Cardo-Regular", size: 25))
                                
                                Text(productDetails)
                                        .font(.custom("Cardo-Regular", size: 20))
                                      
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(10)
                                
                                .frame(height: 100)
                                HStack(alignment: .center, spacing: 15) {
                                    Text("Sizes")
                                        .font(.custom("Cardo-Regular", size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                    Text("Colors")
                                        .font(.custom("Cardo-Regular", size: 15))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                }
                                Text(location)
                                    .font(.custom("Cardo-Regular", size: 25))
                                
                                Image("loveurself")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .cornerRadius(20)
                            }
                            .foregroundColor(.white)
                        }
                    Spacer()
                }

            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.left")) \(name)")
                }
            }
        }
    }
}
