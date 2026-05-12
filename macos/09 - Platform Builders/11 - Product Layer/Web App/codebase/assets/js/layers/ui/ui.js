/* ========================================= */
/* ICOS WEB APP — UI LAYER                   */
/* ========================================= */

import { SystemState, safeExecute } from "../system/system.js";
import { AuthState, isAuthenticated } from "../auth/auth.js";
import { DashboardState } from "../dashboard/dashboard.js";

// UI state
export const UIState = {
    initialized: false,
    theme: "dark",
    mounted: false
};

// Initialize UI system
export function initUI() {
    return safeExecute(() => {
        UIState.initialized = true;
        console.log("UI layer initialized");
        return UIState;
    }, "ui.init");
}

// Mount UI based on auth state
export function mountUI() {
    return safeExecute(() => {
        if (!isAuthenticated()) {
            throw new Error("UI cannot mount without authentication");
        }

        UIState.mounted = true;
        renderUI();

        return UIState;
    }, "ui.mount");
}

// Render UI
function renderUI() {
    console.log("UI rendering...");

    if (DashboardState.mounted) {
        console.log("Dashboard UI active");
    }
}

// Theme toggle
export function toggleTheme() {
    return safeExecute(() => {
        UIState.theme = UIState.theme === "dark" ? "light" : "dark";
        console.log("Theme switched to:", UIState.theme);
        return UIState.theme;
    }, "ui.theme");
}

// Boot UI automatically
initUI();
