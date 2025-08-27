//
//  PasswordView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/12/25.
//

import SwiftData
import SwiftUI

struct PasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var password: String = ""
    @State private var isPasswordShowing: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @Binding var isLoggedIn: Bool
    
    let email: String?
    
    init(email: String? = nil, isLoggedIn: Binding<Bool>) { // Email can be nil
        self.email = email
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 236/255, green: 208/255, blue: 245/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // Back arrow
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    // Title
                    Text("Enter Your Password")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    // Show email if provided
                    if let email = email {
                        Text("Email: \(email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer().frame(height: 30)
                    
                    // Password label and field
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Password")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        
                        HStack {
                            if isPasswordShowing {
                                TextField("Enter your password", text: $password)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            
                            Button(action: {
                                isPasswordShowing.toggle()
                            }) {
                                Image(systemName: isPasswordShowing ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .cornerRadius(8)
                        
                        // Continue Button
                        Button(action: {
                            Task {
                                await handleLogin()
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Continue")
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canContinue ? Color.black : Color.gray)
                            .cornerRadius(8)
                            .shadow(radius: canContinue ? 3 : 0)
                        }
                        .disabled(!canContinue || isLoading)
                        .opacity(canContinue ? 1.0 : 0.5)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Logo
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))
                    
                    Spacer().frame(height: 60)
                }
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
            }
        }
        .alert("Login Status", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Helper Properties
    
    private var canContinue: Bool {
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Password Validation
    
    private func validatePassword(_ password: String) -> ValidationResult {
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmed.count >= 6 else {
            return ValidationResult(isValid: false, message: "Password must be at least 6 characters long")
        }
        
        guard trimmed.count <= 128 else {
            return ValidationResult(isValid: false, message: "Password is too long")
        }
        
        let hasLetters = trimmed.rangeOfCharacter(from: .letters) != nil
        let hasNumbers = trimmed.rangeOfCharacter(from: .decimalDigits) != nil
        
        guard hasLetters || hasNumbers else {
            return ValidationResult(isValid: false, message: "Password must contain letters or numbers")
        }
        
        return ValidationResult(isValid: true, message: "Password is good to go!")
    }
    
    // MARK: - Login Handler
    
    private func handleLogin() async {
        await MainActor.run { isLoading = true } // runs on the main UI thread
        
        let validation = validatePassword(password)
        
        guard validation.isValid else {
            await MainActor.run {
                alertMessage = validation.message
                showingAlert = true
                isLoading = false
            }
            return
        }
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        await MainActor.run {
            isLoading = false
            isLoggedIn = true
            
            // Save user session
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(email ?? "user@example.com", forKey: "userEmail")
            UserDefaults.standard.set(Date(), forKey: "loginDate")
        }
    }
}

// MARK: - Supporting Structs

struct ValidationResult {
    let isValid: Bool
    let message: String
}

// MARK: - Preview

#Preview {
    PasswordView(email: "test@example.com", isLoggedIn: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
