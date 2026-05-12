/****************************************/
/* ICOS WEB APP — AUTH LAYER             */
/****************************************/

import { SystemState, safeExecute } from "../system/system.js";
// BRIDGE (design consistency layer)
import { loadTokens, resolveStyle, initBridge } from "../../../../bridge/design/bridge.tokens.js";

// Auth state
export const AuthState = {
    authenticated: false,
    user: null,
    token: null
};

// Initialize auth layer (bridge-aware)
export async function initAuth() {
    return safeExecute(async () => {
        await initBridge();
        await loadTokens();

        console.log("Auth layer initialized (bridge mode)");
        return true;
    }, "auth.init");
}

// Mock authentication service
export function login(username, password) {
    return safeExecute(() => {
        if (!username || !password) {
            throw new Error("Missing credentials");
        }

        AuthState.authenticated = true;
        AuthState.user = { username };
        AuthState.token = "mock-token-icos";

        return AuthState;
    }, "auth.login");
}

// Logout
export function logout() {
    return safeExecute(() => {
        AuthState.authenticated = false;
        AuthState.user = null;
        AuthState.token = null;
    }, "auth.logout");
}

// Auth check
export function isAuthenticated() {
    return AuthState.authenticated;
}
