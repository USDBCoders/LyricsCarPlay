import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var track: Track?
    @Published var lyrics: [LyricLine] = []
    @Published var currentIndex = 0
    @Published var offset: TimeInterval = 0
    @Published var isRecognizing = false
    @Published var errorMessage: String?

    private let recognizer = ShazamRecognitionService()
    private let provider: any LyricsProviding = DemoLyricsProvider()
    private let activities = ActivityManager()
    private var startedAt = Date()
    private var timer: Timer?

    var currentLine: LyricLine? { lyrics.indices.contains(currentIndex) ? lyrics[currentIndex] : nil }
    var nextLine: LyricLine? { lyrics.indices.contains(currentIndex + 1) ? lyrics[currentIndex + 1] : nil }

    func recognize() async {
        errorMessage = nil; isRecognizing = true
        defer { isRecognizing = false }
        do { try await start(track: recognizer.recognize()) }
        catch { errorMessage = error.localizedDescription }
    }

    func startDemo() async {
        try? await start(track: Track(id: "demo", title: "Morceau de démonstration", artist: "Artiste", duration: 42))
    }

    private func start(track: Track) async throws {
        self.track = track
        lyrics = try await provider.lyrics(for: track)
        startedAt = Date(); offset = 0; currentIndex = 0
        timer?.invalidate()
        timer = .scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in await self?.tick() }
        }
        await tick()
    }

    func adjust(_ seconds: TimeInterval) { offset += seconds; Task { await tick() } }

    func stop() async {
        timer?.invalidate(); timer = nil; recognizer.stop()
        await activities.end()
    }

    private func tick() async {
        guard let track, !lyrics.isEmpty else { return }
        let time = max(0, Date().timeIntervalSince(startedAt) + offset)
        currentIndex = lyrics.lastIndex(where: { $0.startTime <= time }) ?? 0
        let line = lyrics[currentIndex]
        let span = max(0.1, line.endTime - line.startTime)
        let progress = min(1, max(0, (time - line.startTime) / span))
        await activities.update(track: track, line: line.text, nextLine: nextLine?.text, progress: progress)
    }
}

