import Foundation

/// iOS playback-state bridge. Actual AVAudioPlayer playback is implemented separately.
public final class SoundManager {
    public static let shared = SoundManager()
    public static func getInstance() -> SoundManager { shared }
    public var recentlyStoppedSoundfilePaths: Set<SoundFilePathWithSprite> = []
    public var mediaPlayers: [SoundPlaybackState] = []
    private init() {}
}

public final class SoundPlaybackState {
    public var isPlaying: Bool
    public var startedBySprite: Sprite?
    public var pathToSoundFile: String
    public var currentPosition: Float
    public init(isPlaying: Bool = false, startedBySprite: Sprite? = nil, pathToSoundFile: String = "", currentPosition: Float = 0) {
        self.isPlaying = isPlaying; self.startedBySprite = startedBySprite; self.pathToSoundFile = pathToSoundFile; self.currentPosition = currentPosition
    }
}
