import Foundation

enum ICOSSoundTokens {
    static let launchSoundResource = "IntelligenceRuntimeLaunch"
    static let launchSoundExtension = "mp3"

    static var launchSoundURL: URL? {
        Bundle.main.url(forResource: launchSoundResource, withExtension: launchSoundExtension, subdirectory: "Sounds")
            ?? Bundle.main.url(forResource: launchSoundResource, withExtension: launchSoundExtension, subdirectory: "Resources/Sounds")
            ?? Bundle.main.url(forResource: launchSoundResource, withExtension: launchSoundExtension)
    }
}
