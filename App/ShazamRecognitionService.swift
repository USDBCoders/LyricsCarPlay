import Foundation
import ShazamKit
import AVFoundation

@MainActor
final class ShazamRecognitionService: NSObject, SHSessionDelegate {
    private let session = SHSession()
    private let engine = AVAudioEngine()
    private var continuation: CheckedContinuation<Track, Error>?

    override init() {
        super.init()
        session.delegate = self
    }

    func recognize() async throws -> Track {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            do {
                let input = engine.inputNode
                let format = input.outputFormat(forBus: 0)
                input.installTap(onBus: 0, bufferSize: 2048, format: format) { [weak self] buffer, time in
                    self?.session.matchStreamingBuffer(buffer, at: time)
                }
                try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement)
                try AVAudioSession.sharedInstance().setActive(true)
                try engine.start()
            } catch {
                stop(); continuation.resume(throwing: error); self.continuation = nil
            }
        }
    }

    func session(_ session: SHSession, didFind match: SHMatch) {
        guard let item = match.mediaItems.first, let continuation else { return }
        stop()
        self.continuation = nil
        continuation.resume(returning: Track(
            id: item.shazamID ?? UUID().uuidString,
            title: item.title ?? "Titre inconnu",
            artist: item.artist ?? "Artiste inconnu",
            duration: 0
        ))
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        guard let continuation else { return }
        stop(); self.continuation = nil
        continuation.resume(throwing: error ?? LyricsError.unavailable)
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

