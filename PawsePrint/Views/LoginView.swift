//
//  LoginView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/12/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @State private var email: String = "" // State tells Xcode to update the UI when the variable changes
    @State private var showingPasswordView = false
    @Binding var isLoggedIn: Bool
    
    // Email validation
    private var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private var canContinue: Bool {
        !email.isEmpty && isValidEmail
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background Color
                Color(red: 236/255, green: 208/255, blue: 245/255)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Spacer().frame(height: 40)
                        
                        // Title
                        Text("Login or Signup")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .foregroundColor(.black)
                                .font(.subheadline)
                            
                            TextField("Enter your email", text: $email)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            email.isEmpty
                                                ? Color.black
                                                : (isValidEmail ? Color.black : Color.red),
                                            lineWidth: 1
                                        )
                                )
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                            
                            if !email.isEmpty && !isValidEmail {
                                Text("Please enter a valid email address")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Continue Button
                        Button(action: {
                            if canContinue {
                                showingPasswordView = true
                            }
                        }) {
                            HStack {
                                Text("Continue")
                                    .foregroundColor(.white)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canContinue ? Color.black : Color.gray)
                            .cornerRadius(8)
                            .shadow(radius: canContinue ? 3 : 0)
                        }
                        .disabled(!canContinue)
                        .opacity(canContinue ? 1.0 : 0.5)
                        
                        Spacer().frame(height: 20)
                        
                        // Logo
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))
                        
                        Spacer().frame(height: 60)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $showingPasswordView) {
                PasswordView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
