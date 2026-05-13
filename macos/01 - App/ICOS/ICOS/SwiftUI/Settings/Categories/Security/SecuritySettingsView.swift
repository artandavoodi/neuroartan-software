import SwiftUI

// MARK: - Security Settings View

struct SecuritySettingsView: View {
    var body: some View {
        SettingsCategoryShell(
            title: "Security",
            subtitle: "Sign in, sessions, trust, linked accounts, 2FA, and impersonation defense.",
            tabs: [
                SettingsCategoryTabItem(id: "antiImpersonation", title: "Anti Impersonation") { AnyView(SecurityAntiImpersonationTab()) },
            SettingsCategoryTabItem(id: "linkedAccounts", title: "Linked Accounts") { AnyView(SecurityLinkedAccountsTab()) },
            SettingsCategoryTabItem(id: "sessions", title: "Sessions") { AnyView(SecuritySessionsTab()) },
            SettingsCategoryTabItem(id: "signIn", title: "Sign In") { AnyView(SecuritySignInTab()) },
            SettingsCategoryTabItem(id: "trust", title: "Trust") { AnyView(SecurityTrustTab()) },
            SettingsCategoryTabItem(id: "twoFactor", title: "Two Factor") { AnyView(SecurityTwoFactorTab()) }
            ]
        )
    }
}
