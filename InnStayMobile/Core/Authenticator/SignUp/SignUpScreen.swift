//
//  SignUpScreen.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

struct SignupScreen: View {
    
    let onSignupSuccess: () -> Void
    let onGoToLogin: () -> Void
    
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
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
                    CustomTextField(title: "Username", text: $username, keyboardType: .numberPad)
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
                    performSignup(onSuccess: onSignupSuccess)
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
                        onGoToLogin()
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
    
    func performSignup(onSuccess: @escaping () -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/api/auth/register") else {
            print("Invalid signup URL")
            return
        }

        let body: [String: String] = [
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "phone_number": phoneNumber,
            "email": email,
            "password": password,
            "role": "user"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Signup error:", error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response")
                return
            }

            print("Signup response: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    onSuccess()
                }
            } else {
                print("Signup failed with code:", httpResponse.statusCode)
            }
        }.resume()
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
    SignupScreen(
        onSignupSuccess: {},
        onGoToLogin: {}
    )
}
