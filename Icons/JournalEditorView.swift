//
//  JournalEditorView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/14/25.
//

import SwiftUI

// Journal Editor View for user
struct JournalEditorView: View {
    @Binding var entry: JournalEntry
    let onSave: (JournalEntry) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var entryText: String = ""
    
    var body: some View {
        VStack {
            headerView
            promptView
            textEditorView
            Spacer()
        }
        .onAppear {
            entryText = entry.content
        }
        .onChange(of: entry.id) {
            entryText = entry.content
        }
    }
}

// Header for JournalEditorView
private extension JournalEditorView {
    var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(Color(red: 236/255, green: 208/255, blue: 245/255))
            
            Spacer()
            
            Button("Save") {
                entry.content = entryText
                onSave(entry)
                dismiss()
            }
            .foregroundColor(Color(red: 236/255, green: 208/255, blue: 245/255))
        }
        .padding()
    }

    // Popup Prompt for User
    var promptView: some View {
        VStack {
            Text("Journal")
                .font(.custom("Inter", size: 29).weight(.medium))
                .lineSpacing(44)
                .foregroundColor(Color(red: 68/255, green: 85/255, blue: 90/255))

            Text(entry.prompt)
                .font(.custom("Inter", size: 12).weight(.medium))
                .lineSpacing(18)
                .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
        }
    }

    var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            LinesBackground()
                .frame(minHeight: 400)
            
            ZStack(alignment: .topLeading) {
                
                if entryText.isEmpty {
                    Text("Tap to insert your thoughts...")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .lineLimit(nil)
                        .foregroundColor(.gray)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 20)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $entryText)
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .lineLimit(nil)
                    .padding()
                    .background(Color.clear)
                
            }
            
        }
    }
}

struct LinesBackground: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }
}
        
    
