//
//  LoginScreen.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @Binding var path: NavigationPath
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            
            // Logo or App Title
            VStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.pink)
                
                Text("InnStay")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    
            }
            .padding(.top, 60)
            
            // Input Fields
            VStack(spacing: 20) {
                // Email
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                // Password
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Login Button
            Button {
                print("Log in tapped")
                // Trigger view model login here
            } label: {
                Text("Log In")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            // Forgot Password
            Button {
                print("Forgot password tapped")
            } label: {
                Text("Forgot your password?")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Signup prompt
            HStack {
                Text("Don't have an account?")
                Button("Sign up") {
                    path = NavigationPath()
                    path.append(AuthRoute.signup)
                }
                .fontWeight(.semibold)
            }
            .font(.footnote)
            .padding(.bottom)
        }
        .padding(.horizontal, 32)
        .background(Color.white)
    }
}

#Preview {
    LoginScreen(path: .constant(NavigationPath()))
}
