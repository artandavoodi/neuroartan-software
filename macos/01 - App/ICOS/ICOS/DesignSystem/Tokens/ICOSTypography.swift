import SwiftUI

enum ICOSTypography {
    static let sansFamily = "DMSans"

    static let title = Font.system(size: 24, weight: .semibold)
    static let section = Font.system(size: 15, weight: .semibold)
    static let body = Font.system(size: 13, weight: .regular)
    static let bodyStrong = Font.system(size: 13, weight: .semibold)
    static let caption = Font.system(size: 11, weight: .regular)
    static let micro = Font.system(size: 10, weight: .regular)
    static let monoCaption = Font.system(size: 11, design: .monospaced)

    static let heroDisplay = Font.custom(sansFamily, size: 96, relativeTo: .largeTitle).weight(.thin)
    static let displaySection = Font.custom(sansFamily, size: 32, relativeTo: .largeTitle).weight(.light)
    static let displayPanel = Font.custom(sansFamily, size: 17, relativeTo: .title3).weight(.regular)
    static let displayBody = Font.custom(sansFamily, size: 14, relativeTo: .body).weight(.light)
    static let displayBodyStrong = Font.custom(sansFamily, size: 14, relativeTo: .body).weight(.medium)
    static let displayLabel = Font.custom(sansFamily, size: 11, relativeTo: .caption).weight(.regular)

    static let panelTitle = displayPanel
    static let labelSmall = displayLabel
}
