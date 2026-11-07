import SwiftUI

@main
@MainActor
struct FreetifyApp: App {
    @StateObject private var library: LibraryStore
    @StateObject private var player: PlayerService
    @StateObject private var importer: ImportService
    @StateObject private var appleMusic: AppleMusicImporter
    @StateObject private var downloader: OnlineDownloader
    @StateObject private var ui = UIState()

    init() {
        let library = LibraryStore()
        let player = PlayerService(library: library)
        let importer = ImportService(library: library)
        let appleMusic = AppleMusicImporter(library: library)
        let downloader = OnlineDownloader(library: library)
        library.onTracksDeleted = { [weak player] ids in
            player?.removeTracks(ids)
        }
        _library = StateObject(wrappedValue: library)
        _player = StateObject(wrappedValue: player)
        _importer = StateObject(wrappedValue: importer)
        _appleMusic = StateObject(wrappedValue: appleMusic)
        _downloader = StateObject(wrappedValue: downloader)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(library)
                .environmentObject(player)
                .environmentObject(importer)
                .environmentObject(appleMusic)
                .environmentObject(downloader)
                .environmentObject(ui)
                .preferredColorScheme(.dark)
                .tint(Theme.accent)
        }
    }
}

/// État d'interface partagé (sélecteur de fichiers, lecteur plein écran).
@MainActor
final class UIState: ObservableObject {
    @Published var showImporter = false
    @Published var showFullPlayer = false
    @Published var showAppleMusicImport = false
}
