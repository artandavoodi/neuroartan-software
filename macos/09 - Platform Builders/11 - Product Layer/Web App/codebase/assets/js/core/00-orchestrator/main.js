/* ========================================= */
/* ICOS WEB APP — MAIN ENTRY (CORE LOGIC)    */
/* ========================================= */

// ==========================================
// MODULE IMPORTS (LAYERED)
// ==========================================

import "../../layers/system/system.js";
import "../../layers/auth/auth.js";
import "../../layers/dashboard/dashboard.js";
import "../../layers/ui/ui.js";

// BRIDGE SYSTEM
import { initBridge, loadTokens } from "../../../bridge/design/bridge.tokens.js";

// LAYER INITIALIZERS
import { initAuth } from "../../layers/auth/auth.js";
import { initDashboard } from "../../layers/dashboard/dashboard.js";
import { initUI } from "../../layers/ui/ui.js";


// ==========================================
// FRAGMENT MOUNT SYSTEM (LIKE WEBSITE)
// ==========================================

async function loadFragments() {
    const includes = document.querySelectorAll('[data-include]');

    for (const el of includes) {
        const file = el.getAttribute('data-include');

        try {
            const res = await fetch(file);
            const html = await res.text();
            el.innerHTML = html;
        } catch (err) {
            console.error('Fragment load failed:', file);
        }
    }
}


// ==========================================
// BOOTSTRAP
// ==========================================

async function init() {
    // 1. Bridge initialization (single source of truth)
    await initBridge();
    await loadTokens();

    // 2. Core layer initialization
    await initAuth();
    await initDashboard();
    await initUI();

    // 3. Mount UI fragments
    await loadFragments();

    console.log('ICOS Web App initialized (bridge-aligned OS)');
}

init();