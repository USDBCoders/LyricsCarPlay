import ActivityKit
import Foundation

@MainActor
final class ActivityManager {
    private var activity: Activity<LyricsActivityAttributes>?

    func update(track: Track, line: String, nextLine: String?, progress: Double) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let state = LyricsActivityAttributes.ContentState(
            line: line, nextLine: nextLine, title: track.title,
            artist: track.artist, progress: progress
        )
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(15))
        if let activity {
            await activity.update(content)
        } else {
            activity = try? Activity.request(
                attributes: LyricsActivityAttributes(trackID: track.id),
                content: content,
                pushType: nil
            )
        }
    }

    func end() async {
        guard let activity else { return }
        await activity.end(nil, dismissalPolicy: .immediate)
        self.activity = nil
    }
}

