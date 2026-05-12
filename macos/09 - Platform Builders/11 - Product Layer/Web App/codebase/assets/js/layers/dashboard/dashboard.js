/* ========================================= */
/* ICOS WEB APP — DASHBOARD LAYER (BRIDGE)   */
/* ========================================= */

import { SystemState, safeExecute } from "../system/system.js";
import { AuthState, isAuthenticated } from "../auth/auth.js";

// BRIDGE (design consistency layer)
import { loadTokens, resolveStyle, initBridge } from "../../../../bridge/design/bridge.tokens.js";

// Dashboard state
export const DashboardState = {
    mounted: false,
    lastCommand: null,
    logs: []
};

// Initialize dashboard (bridge-aware)
export async function initDashboard() {
    return safeExecute(async () => {
        await initBridge();
        await loadTokens();

        console.log("Dashboard layer initialized (bridge mode)");
        return true;
    }, "dashboard.init");
}

// Mount dashboard
export function mountDashboard() {
    return safeExecute(() => {
        if (!isAuthenticated()) {
            throw new Error("Unauthorized dashboard access");
        }

        DashboardState.mounted = true;
        log("Dashboard mounted");

        return DashboardState;
    }, "dashboard.mount");
}

// Execute command
export function executeCommand(cmd) {
    return safeExecute(() => {
        if (!DashboardState.mounted) {
            throw new Error("Dashboard not mounted");
        }

        DashboardState.lastCommand = cmd;

        const result = `[EXECUTED] ${cmd}`;
        log(result);

        return result;
    }, "dashboard.execute");
}

// Log system
function log(message) {
    const entry = {
        timestamp: Date.now(),
        message
    };

    DashboardState.logs.push(entry);
    console.log("[DASHBOARD]", message);
}
