//
//  ProfileView.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI
import Factory

struct ProfileView: View {
    
    @State var viewModel: ProfileViewModel
    @State var profileImage: UIImage?
    @State var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if profileImage != nil {
                        Image(uiImage: profileImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    } else {
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    }
                }
                .onTapGesture { showImagePicker.toggle() }
                Form {
                    Section(header: Text("Personal info")) {
                        TextField("first-name", text: $viewModel.firstName)
                        TextField(LocalizedStringKey("last-name"), text: $viewModel.lastName)
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        SecureField("Password", text: $viewModel.password)
                        DatePicker("Date of birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                        Toggle("Subscriber", isOn: $viewModel.isSubscriber)
                    }
                    if !viewModel.errors.isEmpty {
                        ForEach(viewModel.errors, id: \.self) {
                            Text($0).foregroundColor(.red)
                        }
                    }
                    if viewModel.isSubscriber {
                        Section(header: Text("Card info")) {
                            TextField("Card number", text: $viewModel.cardNumber)
                            TextField("CVV", text: $viewModel.cardCvv)
                            DatePicker("Expiration date", selection: $viewModel.cardExpirationDate, displayedComponents: .date)
                        }
                    }
                }
                Button(action: {}) {
                    Text("Save")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                }
                .cornerRadius(8)
                Spacer()
            }
            .navigationTitle("Profile")
            //.navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(selectedImage: $profileImage, source: .photoLibrary)
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: Container.shared.profileViewModel())
}
