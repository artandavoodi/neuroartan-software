import CoreText
import Foundation

enum ICOSFontRegistry {
    private static let bundledFontFiles = [
        "DMSans-ExtraLight",
        "DMSans-Light",
        "DMSans-Regular",
        "DMSans-Medium"
    ]

    static func registerBundledFonts() {
        for name in bundledFontFiles {
            guard let url = fontURL(named: name) else {
                #if DEBUG
                print("[ICOSFontRegistry] missing bundled font: \(name).ttf")
                #endif
                continue
            }

            var error: Unmanaged<CFError>?
            let registered = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            guard !registered, let retainedError = error?.takeRetainedValue() else { continue }

            let domain = CFErrorGetDomain(retainedError) as String
            let code = CFErrorGetCode(retainedError)
            let alreadyRegisteredCode = 105
            if domain != "com.apple.CoreText.CTFontManagerErrorDomain" || code != alreadyRegisteredCode {
                #if DEBUG
                print("[ICOSFontRegistry] failed to register \(name): \(retainedError)")
                #endif
            }
        }
    }

    private static func fontURL(named name: String) -> URL? {
        let bundle = Bundle.main
        return bundle.url(forResource: name, withExtension: "ttf", subdirectory: "Fonts")
            ?? bundle.url(forResource: name, withExtension: "ttf", subdirectory: "Resources/Fonts")
            ?? bundle.url(forResource: name, withExtension: "ttf")
    }
}
