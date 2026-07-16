import Foundation

protocol LyricsProviding: Sendable {
    func lyrics(for track: Track) async throws -> [LyricLine]
}

enum LyricsError: LocalizedError {
    case unavailable
    var errorDescription: String? { "Paroles horodatées indisponibles." }
}

/// Démonstration uniquement. Remplacez cette classe par un fournisseur de paroles licencié.
struct DemoLyricsProvider: LyricsProviding {
    func lyrics(for track: Track) async throws -> [LyricLine] {
        let texts = [
            "La musique commence…",
            "Première ligne de démonstration",
            "La route défile doucement",
            "Une seule ligne reste affichée",
            "Recalage possible depuis l’iPhone",
            "Fin de la démonstration"
        ]
        return texts.enumerated().map { index, text in
            let start = Double(index) * 7
            return LyricLine(startTime: start, endTime: start + 7, text: text)
        }
    }
}

