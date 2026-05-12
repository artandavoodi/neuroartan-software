#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"

cd "$APP_ROOT"

xcodebuild \
    -scheme ICOS \
    -configuration Debug \
    build \
    ENABLE_APP_INTENTS_METADATA_GENERATION=NO
