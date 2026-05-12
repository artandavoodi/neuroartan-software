/* ========================================= */
/* ICOS WEB APP — SYSTEM LAYER               */
/* ========================================= */

// Global system state
export const SystemState = {
    initialized: false,
    version: "1.0.0",
    mode: "runtime"
};

// Core system initializer
export function initSystem() {
    SystemState.initialized = true;
    console.log("System layer initialized");
}

// Safe execution wrapper
export function safeExecute(fn, context = "system") {
    try {
        return fn();
    } catch (err) {
        console.error(`[${context}] execution error:`, err);
    }
}

// Boot hook
initSystem();