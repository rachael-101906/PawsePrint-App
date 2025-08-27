//
//  Music.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/14/25.
//

import SwiftUI
import AVFoundation

// MARK: - Music Player ViewModel
class MusicPlayerViewModel: ObservableObject {
    @Published var currentlyPlaying: String? = nil
    private var audioPlayer: AVAudioPlayer?

    let musicOptions = [
        MusicOption(id: "calm", name: "Calm Ambient Guitar", filename: "calm"),
        MusicOption(id: "happy", name: "Happy Uplifting Lo-Fi", filename: "happy"),
        MusicOption(id: "chill", name: "Gentle Nature Lo-Fi", filename: "chill")
    ]
            // Music downloaded from Pixabay
    
    func playMusic(_ music: MusicOption) {
        // Stop current if same
        if currentlyPlaying == music.id {
            stopMusic()
            return
        }
        
        guard let soundURL = Bundle.main.url(forResource: music.filename, withExtension: "mp3") else {
            print("Could not find audio file: \(music.filename).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Loop forever
            audioPlayer?.play()
            currentlyPlaying = music.id
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        currentlyPlaying = nil
    }
}

// MARK: - Music Button View
struct MusicButtonView: View {
    @Binding var showMusicPopup: Bool
    
    var body: some View {
        Button(action: { showMusicPopup.toggle() }) {
            Image("Music")
                .resizable()
                .frame(width: 46, height: 46)
                .shadow(radius: 6)
        }
        .padding()
    }
}

// MARK: - Music Popup View
struct MusicPopupView: View {
    @Binding var showMusicPopup: Bool
    @EnvironmentObject var musicPlayer: MusicPlayerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a song for your mood!")
                .foregroundColor(.black)
                .font(.title2)
            
            VStack(spacing: 15) {
                ForEach(musicPlayer.musicOptions) { music in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(music.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Tap the star to play!")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            musicPlayer.playMusic(music)
                        }) {
                            Image(systemName: musicPlayer.currentlyPlaying == music.id ? "star.fill" : "star")
                                .foregroundColor(musicPlayer.currentlyPlaying == music.id ? .yellow : .gray)
                                .font(.system(size: 24))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            
            Button("Stop Music") {
                musicPlayer.stopMusic()
            }
            .foregroundColor(.red)
            
            Button("Close") {
                showMusicPopup = false
            }
            .foregroundColor(.gray)
        }
        .padding(25)
        .frame(width: 350, height: 400)
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

// MARK: - Music Option Model
struct MusicOption: Identifiable {
    let id: String
    let name: String
    let filename: String
}

// MARK: - Preview
#Preview {
    MusicPopupView(showMusicPopup: .constant(true))
        .environmentObject(MusicPlayerViewModel())
}
