# ICOS Xcode Adapter Injection Plan

## Goal
Extend ICOS beyond VS Code / Continue into Apple-native development.

## Target Architecture
Xcode / Swift project
→ ICOS CLI
→ Xcode adapter
→ runtime router
→ command registry
→ build/test/verify loop
→ institutional memory

## Required Capabilities
- scan Xcode projects
- resolve .xcodeproj / .xcworkspace
- detect schemes
- run xcodebuild
- classify Swift build errors
- classify test failures
- resolve SwiftUI file ownership
- verify simulator/macOS app runtime state
- connect results to ICOS memory and failure learning

## Fill Order
1. 02_xcode_project_scanner.py
2. 03_xcode_scheme_resolver.py
3. build/02_xcodebuild_runner.py
4. build/03_build_error_classifier.py
5. project/03_swift_file_owner_resolver.py
6. verification/01_simulator_runtime_verifier.py
7. interfaces/cli/xcode/01_xcode_cli_commands.py
8. register Xcode commands in core command registry
9. wire Xcode adapter into runtime router
10. connect failures to failure learning engine

## Rule
No direct Xcode mutation before:
- project scan
- scheme resolution
- build command verification
- ownership resolution
