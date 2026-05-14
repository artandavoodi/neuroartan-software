/* ========================================= */
/* NEUROARTAN OS — DESIGN TOKEN BRIDGE       */
/* ========================================= */

/**
 * This bridge ensures SINGLE SOURCE OF TRUTH for design tokens.
 * All tokens originate from WEBSITE system.
 * Web App is CONSUMER ONLY.
 */

// =========================================
// SOURCE OF TRUTH (WEBSITE SYSTEM)
// =========================================

export const TOKEN_SOURCE = {
    basePath: "/website/assets/css/core/01-tokens",
    themePath: "/website/assets/js/core/02-systems/theme.js"
};

// =========================================
// CACHE (RUNTIME STATE)
// =========================================

let tokenCache = null;
let themeCache = null;

// =========================================
// TOKEN LOADER (FROM WEBSITE)
// =========================================

export async function loadTokens() {
    if (tokenCache) return tokenCache;

    try {
        const res = await fetch(TOKEN_SOURCE.basePath + '/tokens.json');
        tokenCache = await res.json();
        return tokenCache;
    } catch (err) {
        console.error("Token bridge load failed:", err);
        return null;
    }
}

// =========================================
// THEME LOADER (FROM WEBSITE)
// =========================================

export async function loadTheme() {
    if (themeCache) return themeCache;

    try {
        const res = await fetch(TOKEN_SOURCE.themePath);
        themeCache = await res.text();
        return themeCache;
    } catch (err) {
        console.error("Theme bridge load failed:", err);
        return null;
    }
}

// =========================================
// TOKEN ACCESS API
// =========================================

export function getToken(path) {
    if (!tokenCache) {
        console.warn("Tokens not loaded yet");
        return null;
    }

    return path.split('.').reduce((obj, key) => obj?.[key], tokenCache);
}

// =========================================
// SAFE RESOLVE (GUARD LAYER)
// =========================================

export function resolveStyle(tokenPath) {
    const value = getToken(tokenPath);

    if (!value) {
        console.warn(`Missing token: ${tokenPath}`);
    }

    return value;
}

// =========================================
// BOOTSTRAP
// =========================================

export async function initBridge() {
    await loadTokens();
    await loadTheme();

    console.log("Design Bridge initialized (single source of truth active)");
}

// auto-init


// SAFE_INIT_BRIDGE

