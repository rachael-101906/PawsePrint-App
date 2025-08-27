//
//  JournalHomeView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/14/25.
//

import SwiftUI
import AVFoundation

struct JournalHomeView: View {
    @State private var showMusicPopup = false
    @State private var journalEntries: [JournalEntry] = [
        {
            var entry = JournalEntry(
                date: Date(),
                prompt: generateRandomPrompt()
            )
            entry.isFirstEntry = true
            return entry
        }()
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderView()
                
                // Main View
                ScrollView {
                    VStack(spacing: 20) {
                        journalEntriesView
                        addEntryButton
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .background(.white)
            .navigationBarHidden(true)
            .overlay(
                MusicButtonView(showMusicPopup: $showMusicPopup),
                alignment: .bottomTrailing
            )
            .overlay(
                Group {
                    if showMusicPopup {
                        ZStack {
                            Color.black.opacity(0.3)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showMusicPopup = false
                                }
                            
                            MusicPopupView(showMusicPopup: $showMusicPopup)
                                .transition(.scale.combined(with: .opacity))
                                .animation(
                                    .spring(response: 0.3, dampingFraction: 0.7),
                                    value: showMusicPopup
                                )
                        }
                    }
                }
            )
        }
    }
}

// MARK: - Journal Entries View
private extension JournalHomeView {
    var journalEntriesView: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(journalEntries.enumerated()), id: \.element.id) { index, entry in
                EntryView(
                    entry: entry,
                    journalEntries: $journalEntries,
                    entryIndex: index
                )
            }
        }
    }
    
    // MARK: - Add New Entry Button 
    var addEntryButton: some View {
        NavigationLink {
            let newEntry = JournalEntry(
                date: Date(),
                prompt: generateRandomPrompt()
            )
            JournalEditorView(
                entry: Binding(
                    get: { newEntry },
                    set: { updatedEntry in
                        journalEntries.append(updatedEntry)
                    }
                ),
                onSave: { updatedEntry in
                    journalEntries.append(updatedEntry)
            }
        )
    } label: {
            HStack {
                Image(systemName: "plus.circle")
                    .frame(width: 18, height: 18)
                    
                Text("Add another journal entry")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.black)
            .padding()
        }
    }
}

// Opening Journal Prompt
struct EntryView: View {
    let entry: JournalEntry
    @Binding var journalEntries: [JournalEntry]
    let entryIndex: Int
    
    var body: some View {
        NavigationLink(destination: JournalEditorView(entry: $journalEntries[entryIndex]) { updatedEntry in
                print("Entry saved: \(updatedEntry.content)")
        }) {
            VStack(alignment: .leading, spacing: 8) {
                
                Ellipse()
                    .foregroundColor(.clear)
                    .frame(width: 60, height: 60)
                    .background(Color(red: 0.93, green: 0.93, blue: 0.94))
                
                HStack(spacing: 10) {
                    Text(entry.dateString)
                        .font(Font.custom("Inter", size: 28.84).weight(.semibold))
                        .lineSpacing(34.60)
                        .foregroundColor(.black)
                }
                
                Text("Today's Journal Prompt")
                    .font(Font.custom("Inter", size: 14).weight(.semibold))
                    .lineSpacing(19.60)
                    .foregroundColor(.black)
                
                Text(entry.prompt)
                    .font(Font.custom("Inter", size: 12).weight(.medium))
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(.black))
                Text(entry.displayEntry)
                    .font(Font.custom("Inter", size: 11).weight(.medium))
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(
                        Color(red: 0.93, green: 0.93, blue: 0.94),
                        lineWidth: 0.50
                    )
            )
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),
                radius: 4, y: 4
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Generate Random Prompts
func generateRandomPrompt() -> String {
    let prompts = [
        "What was the most exciting thing that happened today?",
        "What lessons did I learn today?",
        "What activities did I enjoy the most?",
        "What challenges did I face today?",
        "How did I spend my time today?",
        "What did I accomplish today?",
        "What am I scared for the future, and how can I overcome this?",
        "What am I most grateful for?",
        "What fills me with the most joy?",
        "What are my goals for the future?",
        "What good things do I wish will happen in the next decade?",
        "What motivates me?",
        "What do I want to achieve in my life?",
        "What was my dream job as a child?"
    ]
    return prompts.randomElement() ?? prompts[0]
}

// Journal Entry Data
struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let prompt: String
    var content: String = ""
    var isFirstEntry: Bool = false
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var displayEntry: String {
        if isFirstEntry && content.isEmpty {
            return "This is your first entry! Tap to start writing..."
        }
        return content.isEmpty ? "Tap to start writing..." : content
    }
}

// View Journal Page
struct JournalHomeView_Previews: PreviewProvider {
    static var previews: some View {
        JournalHomeView()
    }
}
