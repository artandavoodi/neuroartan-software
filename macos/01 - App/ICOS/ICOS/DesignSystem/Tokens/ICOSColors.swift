import SwiftUI

// MARK: - Color Tokens
// Global color system. Use theme-aware values instead of hard-coded opacity/color values.

enum ICOSColors {

    // MARK: - Core

    static var accent: Color { Color.accentColor }
    static var background: Color { ICOSMaterials.windowBackground }
    static var surface: Color { ICOSMaterials.panelBackground }
    static var surfaceSecondary: Color { ICOSMaterials.elevatedSurface }

    // MARK: - Text

    static var textPrimary: Color { ICOSMaterials.textPrimary }
    static var textSecondary: Color { ICOSMaterials.textSecondary }
    static var textTertiary: Color { ICOSMaterials.textTertiary }

    // MARK: - Fill

    static var activeFill: Color { ICOSMaterials.pressedSurface }
    static var passiveFill: Color { ICOSMaterials.hoverSurface.opacity(0.56) }
    static var elevatedFill: Color { ICOSMaterials.elevatedSurface }
    static var glassFill: Color { ICOSMaterials.floatingSurface }
    static var avatarFill: Color { ICOSMaterials.hoverSurface }

    // MARK: - State

    static var online: Color { Color.green.opacity(0.85) }
    static var warning: Color { Color.orange.opacity(0.85) }
    static var destructive: Color { Color.red.opacity(0.85) }
}

// MARK: - Sidebar Color Tokens
// Sidebar-specific aliases. Sidebar UI must reference this owner.

enum ICOSSidebarColors {
    static var background: Color { ICOSMaterials.sidebarBackground }
    static var searchFill: Color { ICOSMaterials.floatingSurface }
    static var rowActiveFill: Color { ICOSMaterials.pressedSurface }
    static var rowPassiveFill: Color { ICOSMaterials.hoverSurface.opacity(0.58) }
    static var accountFill: Color { ICOSMaterials.elevatedSurface }
    static var avatarFill: Color { ICOSMaterials.hoverSurface }
    static var separator: Color { ICOSMaterials.softSeparator }
    static var textPrimary: Color { ICOSMaterials.textPrimary }
    static var textSecondary: Color { ICOSMaterials.textSecondary }
    static var textTertiary: Color { ICOSMaterials.textTertiary }
}
