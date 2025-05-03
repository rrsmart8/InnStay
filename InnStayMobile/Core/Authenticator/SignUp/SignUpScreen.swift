//
//  SignUpScreen.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

import SwiftUI

struct SignupScreen: View {
    
    @Binding var path: NavigationPath
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.badge.plus.fill")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.pink)
                    
                    Text("Create Your Account")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding(.top, 60)
                
                // Form Fields
                Group {
                    CustomTextField(title: "First Name", text: $firstName)
                    CustomTextField(title: "Last Name", text: $lastName)
                    CustomTextField(title: "Username", text: $age, keyboardType: .numberPad)
                    CustomTextField(title: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                    CustomTextField(title: "Email", text: $email, keyboardType: .emailAddress)
                    
                    // Password field with eye toggle
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // Sign Up Button
                Button {
                    print("Sign up tapped")
                    // Add validation or call to view model
                } label: {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(.pink)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 16)
                
                // Go back to Login
                HStack {
                    Text("Already have an account?")
                    Button("Log in") {
                            path = NavigationPath()
                            path.append(AuthRoute.login)
                    }
                    .fontWeight(.semibold)
                }
                .font(.footnote)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 32)
        }
        .background(Color.white)
    }
}

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(title, text: $text)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}

#Preview {
    SignupScreen(path: .constant(NavigationPath()))
}
