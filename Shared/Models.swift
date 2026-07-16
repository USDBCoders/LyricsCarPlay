import Foundation
import ActivityKit

struct Track: Codable, Hashable, Sendable {
    let id: String
    let title: String
    let artist: String
    let duration: TimeInterval
}

struct LyricLine: Codable, Hashable, Identifiable, Sendable {
    let id: UUID
    let startTime: TimeInterval
    let endTime: TimeInterval
    let text: String

    init(id: UUID = UUID(), startTime: TimeInterval, endTime: TimeInterval, text: String) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
    }
}

struct LyricsActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let line: String
        let nextLine: String?
        let title: String
        let artist: String
        let progress: Double
    }

    let trackID: String
}

