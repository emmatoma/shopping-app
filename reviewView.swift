import SwiftUI
import UIKit

struct ReviewView: View {
    var restaurantNames = RestaurantConstants.restaurantNames
    let name: String
    @State private var rating = 0
    @State private var showImagePicker = false
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Rate \(name)")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(self.rating >= index ? Color.pink : Color.white)
                            .onTapGesture {
                                self.rating = index
                            }
                    }
                }
                .padding(.top, 20)
                Button(action: {
                    self.showImagePicker = true
                }, label: {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    } else {
                        Text("Add an image")
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 60)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                })
            }
        }
        .onDisappear {
            // Save the rating and image to the RestaurantConstants struct
            RestaurantConstants.ratings[name] = self.rating
            if let image = self.image {
                RestaurantConstants.images[name] = image
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$image)
        })
    }

    func loadImage() {
        guard let inputImage = self.image else { return }
        self.image = inputImage
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        // Set the source type based on the provided parameter
        picker.sourceType = sourceType
        
        return picker
    }


    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = originalImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
