//
//  HeaderView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/14/25.
//

import SwiftUI

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        HStack {
            // Menu Button
            NavigationLink(destination: MenuView()) {
                Image("menu-line")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            // Title
            Text("PawsePrint")
                .font(Font.custom("Inter", size: 20).weight(.semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            // Profile Button
            NavigationLink(destination: ProfileView()) {
                Image("avatar")
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }
}

// MARK: - Menu View
struct MenuView: View {
    var body: some View {
        VStack {
            Text("Menu")
                .font(.title)
                .padding()
            
            List {
                Text("Settings")
                Text("About")
                Text("Help")
                Text("Logout")
                
                NavigationLink(destination: ResourcesView()) {
                    Text("Resources")
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .padding()
            
            Text("This will be your information!")
                .foregroundColor(.gray)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Resources View
struct ResourcesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Need assistance?")
                    .font(Font.custom("Inter", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.bottom, 8)

                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Crisis")
                            .font(Font.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))

                        Text("LSU Mental Health Support Line — 225-924-5781")
                        Text("988 Suicide & Crisis Lifeline — Call or text 988 (24/7, free, confidential)")
                        Text("Crisis Text Line — Text HOME to 741741 (24/7 support via text)")
                        Text("The Trevor Project (for LGBTQ+ youth) — Call 1-866-488-7386 or text START to 678678")
                        Text("Baton Rouge Behavioral Health Center — (225) 922-0445")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("LSU Campus Resources")
                            .font(Font.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))

                        Text("LSU Mental Health Service (MHS) — On-campus counseling & psychiatric care, free for students")
                        Text("Student Health Center — Appointments, workshops, and wellness coaching")
                        Text("Wellness Ambassadors Program — Peer-led mental health support and education")
                        Text("LSU CARE Referral System — For concerns about a student's wellbeing (self or others)")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local Community Resources")
                            .font(Font.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))

                        Text("Capital Area Human Services — Low-cost counseling and substance abuse services")
                        Text("Our Lady of the Lake Behavioral Health — Inpatient & outpatient therapy")
                        Text("Iris Domestic Violence Center — Shelter & legal advocacy for abuse survivors")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("National Mental Health & Wellness Tools")
                            .font(Font.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))

                        Text("BetterHelp Student Plan — Affordable online therapy (discounted for students)")
                        Text("Headspace (Free for some universities) — Guided meditation & mindfulness exercises")
                        Text("Calm — Sleep, stress relief, and relaxation audio")
                        Text("NAMI (National Alliance on Mental Illness) — Education, support groups, and helplines")
                    }
                }
                .font(Font.custom("Inter", size: 14))
                .foregroundColor(.black)
            }
            .padding(20)
        }
        .background(Color(red: 0.81, green: 0.92, blue: 0.96).opacity(0.69))
        .navigationTitle("Resources")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HeaderView()
        }
    }
}
