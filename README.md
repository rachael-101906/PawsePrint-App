# PawsePrint

#### Video Demo:

https://www.canva.com/design/DAGw5j66svs/CGmtlRIVDawGNxwamHud4A/view?utm_content=DAGw5j66svs&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hdb7f4dcb71

#### Description:

Description of project

For my final project for CS50, I created a mental health application called PawsePrint—a play on“pawprint” and “pause.” The app is designed to give students a way to take a mental break and unwind amid the constant chaos of life. Its interface aligns with Louisiana State University’s mascot and color schemes, making it especially tailored for LSU students.

The app includes several core features implemented across different views, including a journal entry prompt, background music selection, sticky notes, and LSU-specific mental health resources.


LoginView

The first screen a user encounters upon opening the app is the LoginView. Here, users register by providing a valid email address. The private variable isValidEmail is a Boolean expression that checks whether the entered email meets the requirements, returning true or false. If isValidEmail is true and the field is not empty, the private variable canContinue also becomes true. If not, text will appear indicating the email is invalid.

The input field’s border color provides immediate feedback: red if the email is invalid and black if it is valid. Once the user enters a valid email, the “Continue” button changes from a gray, semi-transparent theme to a solid black background with full opacity. The button remains disabled unless the email passes validation.

At the bottom of the screen, the PawsePrint logo is displayed. If the entered email meets the required standards, the user can then proceed to the PasswordView. Navigation is handled through a binding variable that redirects the user to the PasswordView and also passes along the isLoggedIn Boolean expression for later use.


PasswordView

The user will be redirected to the PasswordView once they input a successful email. The user can go back to the previous page by pressing the small arrow on the top left corner of the screen, which uses the presentationMode instance to dismiss the current view and return to the previous one.

Further down in the UI, the user will be asked to enter their password while their previously entered email is displayed in gray text. Right under the password label, the user will see a white input box where they can enter their password in either a text field or secure field, depending on the toggle state of the eye icon.

The continue button allows the user to proceed to the next view after successful login. It appears as a black box containing text and an arrow. When the user presses the continue button, they can only proceed if they have met the password requirements. If the requirements haven't been met, the button will remain light gray with reduced opacity and stay disabled. Once they've been verified, the box will turn black, and when pressed, it will display a loading icon inside the box while the user is being redirected.

The other properties and functions are used to validate the entered password and alert the user of their password's status. The canContinue Boolean expression removes any whitespaces that may be in the inputted password and ensures that the password field is not empty.

The validation function is used to check the password and return the validation result that will generate the appropriate alert message. A new instance of the password is created by removing any whitespaces from the text, then tested to ensure it's between 6-128 characters long. It's also tested to verify it contains both letters and numbers. If any of these requirements are not met, the user will receive an error stating their password is not valid. Otherwise, the validation will pass.

After the password is verified, the handleLogin function will run, which creates a copy of the password as "validation" to check if the validation was successful. If not, it will display the alert message. If verified, the program will pause for 0.5 seconds, then change isLoggedIn to true and redirect the user. The program will then save the user session with their login status, email, and the date they logged in.


HomePageView

The HomePageView consists of multiple structs built to split this complex view into distinct, readable parts for the compiler. I originally had everything in one struct under the JournalHomeView, but it was straining my compiler quite a bit. Therefore, I fixed the problem by splitting them up into their own individual structs.

At the top of the JournalHomeView is the built-in HeaderView, which contains an HStack with a menu, PawsePrint title, and the profile view button. This HeaderView is also used as the custom header on this view, the JournalHomeView, and the ToDoView. Below that is the scroll view, where the user can scroll to view the welcome section and the cards section.

The WelcomeSection struct greets the user upon successful login and provides a reiteration of the essential theme of taking a moment to relax.

The CardsSection also contains sub-structs such as the FirstRowCards, SecondRowCards, and ResourcesCard. The FirstRowCards contains the Journal Prompt Card and the NewJournalEntryCard for the user to tap and navigate to either the JournalEditorView or the JournalHomeView. The SecondRowCards contains the ToDoListCard and the MusicCard, where the user can navigate to either play music on the journal page or create sticky notes on the ToDoView.

Each individual card has its own struct that acts as a sneak peek into what the navigation page they're linked to will contain when the user clicks on them.

The very last struct before the previews is the MainTabView. The tab icons become filled whenever they are selected by the user and redirect to the navigation page based on the link used in the struct.

The last two structs are used to preview the HomePageView and the MainTabView together.


JournalHomeView

When the user presses the journal icon in the TabView or the Journal prompt card on the HomePageView, they will be redirected to the JournalHomeView. This is where the user will create their journal entries. Inside a scroll view with a VStack, there are two functions: one for displaying the journal entries and another for adding a new one. When they press on either a new or existing journal entry, they will be redirected to the JournalEditorView where they can edit the entry. The HeaderView can also be seen at the top as well as the tab view at the bottom. In the bottom right corner, an overlay method is used for an icon for optional music that can play in the background while the user is using the app (this will be discussed more in the MusicView section).

There is a private extension under the main view with the variable journalEntriesView, where all the journal entries that a user creates will be arranged in a LazyVStack. Each entry has an index, and they will be arranged according to said index along with the EntryView. Beneath this private extension is the addEntryButton where the user will see a plus icon and journal entry text on the frontend. When they click the addEntryButton, it declares a constant newEntry that opens JournalEditorView and binds the updated entry by calling the append method on the journalEntries array.

Inside EntryView, a similar thing happens, where there is a NavigationLink when the user opens an entry. If the user clicks an entry, EntryView will call JournalEditorView as the destination and create a binding from the entry and the index of the specific entry in the journalEntries array. On the frontend, EntryView displays a blank circle, the date, the prompt title, the prompt question, and the content of the entry (if empty, there is default text in the displayEntry variable inside the JournalEntry struct).

The function generateRandomPrompt() returns a random prompt for the user each time they create a new journal entry.

Finally, there is a struct for JournalEntry (classified as Identifiable to be used with ForEach in the JournalHomeView private extension) that stores each entry's unique id, date, prompt, content, and first entry status. It also creates the dateString that will be used for the date display above each prompt.


JournalEditorView

The JournalEditorView is where the user can edit their entries inside the journalEntries entry. The VStack contains its own headerView, promptVoew, and textEditorView. Whenver the JournalEditorView is opened, the entry.content becomes entryText based on the content of the entry. If the content is changed, the entryText becomes updated with the new content.

The headerView is separate from the other HeaderView that was used in the other screens of the app. This headerView contains a cancel button and a save button on top of the view through a private extension.

The promptView shows the title “Journal” along with the prompt for that specific entry.

The textEditorView shows a line separating the text the user will write from the actual TextEditor using a struct called LinesBackground. If the entry content is empty, the text will generate a default response. If not, the binding entryText will update from the child to parent view what the user types in anything from


MusicView

The last two views are among the most complicated views I had to create for this app. In order for the MusicPlayerViewModel to continue updating, I created it as an ObservableObject so it would update the UI whenever it updates itself. I also want to keep track of what song is playing, whether it's one of my selections or if it is nil.

The constant MusicOptions is where three MusicOption instances store the id, name, and filename of the mp3 files containing the music audio. The next function calls for the ViewModel to play music. If the user tries to play the same file twice, the song will stop. Next, the soundURL constant is defined by taking the filename or returning an error message if not found.

Next, the function tries to play the URL and loops forever by setting the number of loops to negative 1. It then changes the currentlyPlaying to the current music id. If unable to perform the action, it will display an error message. Lastly, there is a function to stop the music by stopping the audioplayer and setting the currentlyPlaying to nil.

The MusicButtonView uses the binding variable from the parent view JournalHomeView to connect to showMusicPopup. In the bottom trailing corner, the MusicButtonView shows the image icon that the user can tap to open the music selection.

The next struct is the MusicPopupView, which has the binding var showMusicPopup once again and the shared MusicPlayerViewModel. Then a VStack contains each music name in an HStack with a star that the user can select to play their chosen song. When they select the star, it changes from unfilled clear to filled yellow. If the user wants to stop the music, they have a stop music button that calls the stopMusic() method, or a close button that changes showMusicPopup to false.

Lastly, the struct MusicOption conforms to Identifiable to use with the ForEach in the MusicPopupView struct and contains constants for the id, name, and filename of the music selections.


ToDoView

The last view was the most complicated and sophisticated view of all to create. The stickyNotes private variable is declared with each individual index of sticky notes containing a date, title, and content. The ToDoView contains the HeaderView and a ScrollView that contains the stickyNotes in a LazyVGrid and an addNoteButton. If the user is editing a sticky note, a ForEach loop is executed and the EditableNoteView opens. If the user is editing the sticky note, the get function checks if the note being edited equals the note's unique id, and if so, when the binding value changes and the sticky note is no longer being edited, the editingNoteId is set to nil. If the sticky note is not being edited, it changes to the NoteView, which displays the card in view mode only.

If the user wants to add a sticky note, the private variable addNoteButton is called with the date, title, and content, each with their own default text before the user edits them. The stickyNotes array is then appended to create the new note.

The NoteView struct is what the user will see in the LazyVGrid when they are no longer editing the note. Each note will be assigned a randomized background color based on five variables, and the top of each note will contain the date as well as a small circle that can be changed from gray to green based on whether the note is completed. The note title is always the default text, and the note content is the default text when unedited or the note's content when the user edits the note. A preview for the to-do items is also shown, and the user may check the circle next to the item to mark it as completed. If it is completed, it will also have a strikethrough applied to the text. If not, the circle will remain unfilled. If the to-do items are greater than three, text will appear at the bottom displaying the count of the other to-do items in the list, and these will appear once the user clicks on the sticky note to transfer to the editable view.

The EditableNoteView is very similar to the NoteView, except when the user presses the checkmark circle, the note returns to NoteView. In addition, new focus states are declared for the user's cursor to focus on either the title, content, or a new to-do item. In an HStack, there is the checkmark circle, the item's title, and then a slashed circle to delete the to-do item based on its index number in the array. At the bottom, there is an option for the user to continue adding new to-do items.

At the bottom there are also two helper functions. One of them is used for adding a new item to the list, where it trims the whitespaces from the text in the to-do items and adds the new item while updating the note's completion status. The second function updates the note completion if the items are not empty and each one is fulfilled.

Lastly, there are two Identifiable structs for the TodoItem and the StickyNote, each with their own id, title, and isCompleted properties. The StickyNote struct also contains the date, content, and todoItems array.


##### Note:

This project was created with the assistance of Claude AI by Anthropic and ChatGPT by OpenAI. I used these tools to deepen my understanding of the code and gain valuable insight into Swift compared to other programming languages I have studied in the past. After building the project, I carefully reviewed the code to ensure I understood each component before submitting it to CS50. I also took notes on the functionality of the code and the structures best suited for certain situations. The use of AI resources does not diminish my own efforts in creating this project, as they served as a guide rather than a generator in my production of PawsePrint. Thank you!

