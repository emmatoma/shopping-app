import Foundation
import UIKit
import SwiftUI
struct UserInfoView: View {
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var showingImagePicker = false
    @State private var image: UIImage? = UIImage(systemName: "person.fill")
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                HStack {
                    Spacer()
                    Image(uiImage: image ?? UIImage(systemName: "person.fill")!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .padding()
                    Spacer()
                }
                
                Button(action: {
                    self.showingImagePicker = true
                }) {
                    Text("Choose Photo")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$image)
                }
                
                Picker("Select a source", selection: $sourceType) {
                    Text("Camera").tag(UIImagePickerController.SourceType.camera)
                    Text("Photo Library").tag(UIImagePickerController.SourceType.photoLibrary)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Name")) {
                TextField("Enter your name", text: $name)
            }
            
            Section(header: Text("Address")) {
                TextEditor(text: $address)
                    .frame(height: 100)
            }
            
            Section(header: Text("Email")) {
                TextField("Enter your email", text: $email)
                    .keyboardType(.emailAddress)
            }
            
            Section(header: Text("Phone Number")) {
                TextField("Enter your phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Button(action: {
                // save information
            }) {
                Text("Save Information")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
        }
        .navigationBarTitle("User Info")
    }
    
    func loadImage() {
        guard let inputImage = image else { return }
        image = inputImage
    }
}

