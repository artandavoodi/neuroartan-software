#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"

cd "$APP_ROOT"

APP_PATH="$(
    xcodebuild \
        -scheme ICOS \
        -configuration Debug \
        -showBuildSettings \
        ENABLE_APP_INTENTS_METADATA_GENERATION=NO \
        | awk -F'= ' '/TARGET_BUILD_DIR/ { dir=$2 } /FULL_PRODUCT_NAME/ { name=$2 } END { print dir "/" name }'
)"

if [[ ! -d "$APP_PATH" ]]; then
    "$SCRIPT_DIR/build_icos_debug.sh" >/dev/null
fi

open -n "$APP_PATH"
