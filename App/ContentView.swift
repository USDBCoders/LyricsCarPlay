import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                if let track = model.track {
                    VStack(spacing: 5) {
                        Text(track.title).font(.title2.bold())
                        Text(track.artist).foregroundStyle(.secondary)
                    }
                }
                Text(model.currentLine?.text ?? "Reconnaissez un morceau pour commencer")
                    .font(.title3.weight(.semibold)).multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 120).padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22))
                if model.track != nil {
                    HStack {
                        Button("−2 s") { model.adjust(-2) }.buttonStyle(.bordered)
Text("Décalage : \(model.offset, specifier: "%.0f") s")
    .monospacedDigit()                        Button("+2 s") { model.adjust(2) }.buttonStyle(.bordered)
                    }
                }
                Spacer()
                Button {
                    Task { await model.recognize() }
                } label: {
                    Label(model.isRecognizing ? "Écoute…" : "Reconnaître le morceau", systemImage: "shazam.logo")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent).disabled(model.isRecognizing)
                Button("Lancer la démonstration") { Task { await model.startDemo() } }
                if let error = model.errorMessage { Text(error).foregroundStyle(.red).font(.footnote) }
            }
            .padding().navigationTitle("Lyrics CarPlay")
        }
    }
}
