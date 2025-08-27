//
//  ToDoView.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/14/25.
//

import SwiftUI
import SwiftData

struct ToDoView: View {
    @State private var showingNotes = false 
    @State private var stickyNotes: [StickyNote] = [
        StickyNote(
            date: Date(),
            title: "Today's Agenda",
            content: "What will you do today?"
        )
    ]
    @State private var editingNoteId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            HeaderView()
            
            // Main View
            ScrollView {
                VStack(spacing: 20) {
                    stickyNotesView
                    addNoteButton
                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .background(.white)
        .navigationBarHidden(true)
    }
    
    // MARK: - Sticky Notes View
    private var stickyNotesView: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 10), // spacing 10 is between columns
                GridItem(.flexible(), spacing: 10)
            ],
            spacing: 16 // spacing 16 is between rows
        ) {
            ForEach($stickyNotes) { $note in
                if editingNoteId == note.id {
                    EditableNoteView(
                        note: $note,
                        isEditing: Binding(
                            get: { editingNoteId == note.id },
                            set: { _ in editingNoteId = nil } // closes out the card
                        )
                    )
                } else {
                    NoteView(note: note) {
                        editingNoteId = note.id // shows the card
                    }
                }
            }
        }
    }
    
    // MARK: - Add New Note Button
    private var addNoteButton: some View {
        Button(action: {
            let newNote = StickyNote(
                date: Date(),
                title: "Today's Agenda",
                content: "What will you do today?"
            )
            stickyNotes.append(newNote)
            editingNoteId = newNote.id
        }) {
            HStack {
                Image(systemName: "plus.circle")
                    .frame(width: 18.89, height: 18)
                Text("Add a sticky note")
                    .font(.system(size: 16, weight: .medium, design: .default))
            }
            .foregroundColor(.black)
            .padding()
        }
    }
}

// MARK: - Individual Note View
struct NoteView: View {
    let note: StickyNote
    let onTap: () -> Void
    
    private var noteColor: Color {
        let colors: [Color] = [
            Color(red: 0.18, green: 0.19, blue: 0.26).opacity(0.50),
            Color(red: 0.93, green: 0.81, blue: 0.96).opacity(0.50),
            Color(red: 0.99, green: 0.99, blue: 0.59).opacity(0.50),
            Color(red: 0.47, green: 0.87, blue: 0.47).opacity(0.50),
            Color(red: 1.0, green: 0.70, blue: 0.28).opacity(0.50)
        ]
        return colors[abs(note.id.hashValue) % colors.count]
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                
                // Top row: completion circle and date
                HStack {
                    Circle()
                        .fill(note.isCompleted ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                        .animation(.easeInOut(duration: 0.2), value: note.isCompleted)
                    
                    Spacer()
                    
                    Text(note.dateString)
                        .font(.caption)
                        .foregroundColor(.black)
                }
                
                // Note title
                Text(note.title)
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                // Note content
                Text(note.content.isEmpty ? "Tap to create to-do list..." : note.content)
                    .font(.system(size: 12))
                    .foregroundColor(note.content.isEmpty ? .gray : .black)
                    .lineLimit(4)
                
                // To-do items preview
                if !note.todoItems.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(note.todoItems.prefix(3).enumerated()), id: \.offset) { index, item in
                            HStack(spacing: 6) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 14))
                                    .foregroundColor(
                                        item.isCompleted ? Color(red: 0.18, green: 0.19, blue: 0.26) : .gray
                                    )
                                Text(item.title)
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                    .strikethrough(item.isCompleted)
                                    .lineLimit(1)
                            }
                        }
                        
                        if note.todoItems.count > 3 {
                            Text("+ \(note.todoItems.count - 3) more items") // shows the other items if it is more than three 
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(noteColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.93, green: 0.93, blue: 0.94), lineWidth: 0.50)
            )
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Editable Note View
struct EditableNoteView: View {
    @Binding var note: StickyNote
    @Binding var isEditing: Bool
    @State private var newTodoText: String = ""
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    @FocusState private var isNewTodoFocused: Bool
    
    private var noteColor: Color {
        let colors: [Color] = [
            Color(red: 0.18, green: 0.19, blue: 0.26).opacity(0.50),
            Color(red: 0.93, green: 0.81, blue: 0.96).opacity(0.50),
            Color(red: 0.99, green: 0.99, blue: 0.59).opacity(0.50),
            Color(red: 0.47, green: 0.87, blue: 0.47).opacity(0.50),
            Color(red: 1.0, green: 0.70, blue: 0.28).opacity(0.50)
        ]
        return colors[abs(note.id.hashValue) % colors.count]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Header: completion circle, date, done button
            HStack {
                Circle()
                    .fill(note.isCompleted ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                    .animation(.easeInOut(duration: 0.2), value: note.isCompleted)
                Spacer()
                Text(note.dateString)
                    .font(.caption)
                    .foregroundColor(.black)
                
                Button(action: { isEditing = false }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 18))
                }
            }
            
            // Title field
            TextField("Note title...", text: $note.title)
                .font(.system(size: 17, weight: .semibold))
                .focused($isTitleFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit { isContentFocused = true }
            
            // To-do list
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(note.todoItems.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 7) {
                        Button(action: {
                            note.todoItems[index].isCompleted.toggle()
                            updateNoteCompletion()
                        }) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 12))
                                .foregroundColor(item.isCompleted ? Color(red: 0.18, green: 0.19, blue: 0.26) : .gray)
                        }
                        
                        Text(item.title)
                            .font(.system(size: 11))
                            .foregroundColor(.black)
                            .strikethrough(item.isCompleted, color: .gray)
                        
                        Spacer()
                        
                        Button(action: {
                            note.todoItems.remove(at: index)
                            updateNoteCompletion()
                        }) {
                            Image(systemName: "circle.slash")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.54, green: 0.35, blue: 0.60))
                        }
                    }
                }
                
                // Add new to-do item
                HStack(spacing: 6) {
                    Image(systemName: "plus.app")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    TextField("Add a bullet...", text: $newTodoText)
                        .font(.system(size: 11))
                        .focused($isNewTodoFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit { addTodoItem() }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(noteColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.50)
                .stroke(Color(red: 0.93, green: 0.93, blue: 0.94), lineWidth: 0.50)
        )
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
        .onAppear { isTitleFocused = true }
    }
    
    // MARK: - Helper Functions
    private func addTodoItem() {
        let trimmedText = newTodoText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            note.todoItems.append(TodoItem(title: trimmedText))
            newTodoText = ""
            updateNoteCompletion()
        }
    }
    
    private func updateNoteCompletion() {
        note.isCompleted = !note.todoItems.isEmpty && note.todoItems.allSatisfy(\.isCompleted)
    }
}

// MARK: - Data Models
struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String = ""
    var isCompleted: Bool = false
}

struct StickyNote: Identifiable {
    let id = UUID()
    let date: Date
    var title: String = ""
    var content: String = ""
    var todoItems: [TodoItem] = []
    var isCompleted: Bool = false
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Preview
struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
