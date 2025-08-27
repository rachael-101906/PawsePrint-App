//
//  HomePageView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/12/25.
//

import SwiftUI
import SwiftData

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        WelcomeSection()
                        CardsSection()
                        Spacer(minLength: 100)
                    }
                }
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Welcome Section
struct WelcomeSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome Tigers!")
                .font(Font.custom("Aclonica", size: 25))
                .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))
                .multilineTextAlignment(.center)
            
            Text("Let's take a pawse for a moment and relax!")
                .font(Font.custom("Jua", size: 20))
                .foregroundColor(Color(red: 0.25, green: 0.46, blue: 0.55))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
}

// MARK: - Cards Section
struct CardsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            FirstRowCards()
            SecondRowCards()
            ResourcesCard()
        }
    }
}

// MARK: - First Row
struct FirstRowCards: View {
    var body: some View {
        HStack(spacing: 12) {
            JournalPromptCard()
            NewJournalEntryCard()
        }
        .padding(.horizontal)
    }
}

// MARK: - Second Row
struct SecondRowCards: View {
    var body: some View {
        HStack(spacing: 12) {
            ToDoListCard()
            MusicCard()
        }
        .padding(.horizontal)
    }
}

// MARK: - Journal Prompt Card
struct JournalPromptCard: View {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    var body: some View {
        NavigationLink(destination: JournalHomeView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Today's Journal Prompt")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Circle()
                    .foregroundColor(Color(red: 0.88, green: 0.88, blue: 0.88))
                    .frame(width: 80, height: 80)
                
                Spacer()
                
                Text(dateFormatter.string(from: Date()))
                    .font(Font.custom("Inter", size: 16).weight(.semibold))
                    .foregroundColor(.black)
            }
            .padding(16)
            .frame(width: 170, height: 200)
            .background(.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4,
                y: 4
            )
        }
    }
}


// MARK: - New Journal Entry Card
struct NewJournalEntryCard: View {
    @State private var showJournalEditor = false
    @State private var newEntry = JournalEntry(date: Date(), prompt: "")
    
    private let journalPrompts = [
        "What's on your mind today? Take a moment to reflect on your thoughts and feelings.",
        "What are three things you're grateful for right now?",
        "Describe a moment today that made you smile.",
        "What challenge are you facing, and how might you approach it?",
        "What would you like to accomplish before the day ends?",
        "How are you feeling emotionally right now, and why?",
        "What's something new you learned recently?",
        "Write about a person who has made a positive impact on your life."
    ]
    
    var body: some View {
        Button(action: {
            let randomPrompt = journalPrompts.randomElement() ?? journalPrompts[0]
            newEntry = JournalEntry(date: Date(), prompt: randomPrompt)
            showJournalEditor = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What's on your mind today?")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Time to share your thoughts! Your journal is waiting.")
                    .font(Font.custom("Inter", size: 18).weight(.medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .frame(width: 170, height: 200)
            .background(.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4,
                y: 4
            )
        }
        .sheet(isPresented: $showJournalEditor) {
            JournalEditorView(
                entry: $newEntry,
                onSave: { savedEntry in
                    print("Journal entry saved: \(savedEntry)")
                }
            )
        }
    }
}


// MARK: - To Do List Card
struct ToDoListCard: View {
    var body: some View {
        NavigationLink(destination: ToDoView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text("To Do List")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Get yourself organized for the day")
                    .font(Font.custom("Inter", size: 18).weight(.medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .frame(width: 170, height: 200)
            .background(.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4,
                y: 4
            )
        }
    }
}

// MARK: - Music Card
struct MusicCard: View {
    @EnvironmentObject var musicPlayer: MusicPlayerViewModel
    @State private var showMusicPopup = false
    
    var body: some View {
        NavigationLink(destination: MusicPopupView(showMusicPopup: $showMusicPopup)) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Music")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Listen to some tunes while you relax")
                    .font(Font.custom("Inter", size: 18).weight(.medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .frame(width: 170, height: 200)
            .background(.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4,
                y: 4
            )
        }
    }
}

// MARK: - Resources Card
struct ResourcesCard: View {
    var body: some View {
        NavigationLink(destination: ResourcesView()) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Mental Health Resources")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.black)

                Spacer()

                Text("""
                LSU Mental Health Support Line — 225-924-5781
                988 Suicide & Crisis Lifeline — Call or text 988 (24/7, free, confidential)
                Crisis Text Line — Text HOME to 741741 (24/7 support via text)
                """)
                .font(Font.custom("Inter", size: 10).weight(.medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4, y: 4
            )
        }
        .padding(.horizontal)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            JournalHomeView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "pencil.tip.crop.circle.badge.plus.fill" : "pencil.tip.crop.circle.badge.plus")
                    Text("Journal")
                }
                .tag(1)
            
            ToDoView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "character.textbox.badge.sparkles" : "character.textbox")
                    Text("To Do")
                }
                .tag(2)
        }
        .accentColor(Color(red: 0.54, green: 0.35, blue: 0.60))
    }
}

// MARK: - Previews
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
