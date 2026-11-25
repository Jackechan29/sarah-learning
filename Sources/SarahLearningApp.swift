import SwiftUI
import AVFoundation

@main struct SarahLearningApp: App {
    var body: some Scene { WindowGroup { LessonView() } }
}

struct LessonView: View {
    @State private var index = 0
    @State private var answer = ""
    @State private var feedback = "Let's learn Polish together!"
    @AppStorage("practiceSuccesses") private var successes = 0
    @State private var speech = AVSpeechSynthesizer()
    private let words = [("Hello","Cześć"),("Milk","Mleko"),("Bread","Chleb"),("Thank you","Dziękuję"),("Good morning","Dzień dobry")]
    var body: some View {
        VStack(spacing: 24) {
            Text("SARAH LEARNING").font(.headline)
            Image(systemName: "sparkles").font(.system(size: 70)).foregroundStyle(.cyan)
            Text(feedback).font(.title2).multilineTextAlignment(.center)
            Text(words[index].0).font(.largeTitle.bold())
            Button("Hear it in Polish") { speak(words[index].1, language: "pl-PL") }.buttonStyle(.borderedProminent)
            TextField("Type your Polish answer", text: $answer).textFieldStyle(.roundedBorder).autocorrectionDisabled()
            Button("Check answer") { check() }.buttonStyle(.borderedProminent)
            Button("Next word") { index = (index + 1) % words.count; answer = ""; feedback = "Ready for another word?" }
            Button("Stop speaking") { speech.stopSpeaking(at: .immediate) }
            Text("Words answered correctly: \(successes)").font(.caption)
        }.padding(32)
    }
    private func speak(_ text: String, language: String) {
        speech.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.42
        speech.speak(utterance)
    }
    private func check() {
        let correct = answer.trimmingCharacters(in: .whitespacesAndNewlines).localizedCaseInsensitiveCompare(words[index].1) == .orderedSame
        if correct { successes += 1; feedback = "Great work! You got it!" }
        else { feedback = "Good try! Listen again and have another go." }
        speak(feedback, language: "en-GB")
    }
}
