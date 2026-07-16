import ActivityKit
import SwiftUI
import WidgetKit

@main
struct LyricsWidgetBundle: WidgetBundle {
    var body: some Widget { LyricsLiveActivity() }
}

struct LyricsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LyricsActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 5) {
                Text(context.state.line).font(.headline).lineLimit(2)
                ProgressView(value: context.state.progress)
                Text("\(context.state.title) — \(context.state.artist)")
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            .padding().activityBackgroundTint(.black.opacity(0.85)).activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.line).font(.headline).multilineTextAlignment(.center).lineLimit(2)
                }
                DynamicIslandExpandedRegion(.bottom) { ProgressView(value: context.state.progress) }
            } compactLeading: {
                Image(systemName: "music.note")
            } compactTrailing: {
                Text("♪")
            } minimal: {
                Image(systemName: "music.note")
            }
        }
    }
}

