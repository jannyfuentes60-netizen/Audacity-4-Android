# Audacity 4 for Android

This project packages the **official Linux ARM64 build of Audacity 4.0.2** inside an Android compatibility app based on [Andacious](https://github.com/CypherpunkArmory/Andacious).

It does not recreate Audacity's interface in Flutter or WebView: it launches the real Audacity desktop application in the Linux environment provided by Andacious.

## Current approach

- Android shell and Linux runtime: Andacious (included as a Git submodule).
- Editor: official Audacity 4.0.2 ARM64 AppImage.
- Architecture: ARM64 devices.
- Integrity: the downloaded AppImage is checked against the SHA-256 published with Audacity 4.0.2.
- Build: GitHub Actions builds a debug APK and uploads it as an artifact.

Audacity 4 is a desktop application and does not officially list Android as a supported platform. This project is therefore a compatibility-layer port, not an official Audacity Android release.

## Build

1. Open the **Actions** tab and run **Build Android APK** (or push a commit).
2. Wait for the build job to finish.
3. Download **Audacity-4-Android-debug** from the run's Artifacts section.

The first app launch downloads and extracts the ARM64 Audacity runtime. Allow time and storage for this initial setup.

## Important

- Requires an ARM64 Android device and enough free storage for the Linux runtime and editor.
- First launch requires internet access.
- This is an early port. Audio input/output, Android file access, and touch usability must be tested on real devices before calling it stable.
- Keep project backups. Do not use experimental builds as the only copy of important work.

## Upstream projects and licenses

- [Audacity](https://github.com/audacity/audacity) — GPL-3.0-or-later; this project downloads its official 4.0.2 ARM64 Linux AppImage.
- [Andacious](https://github.com/CypherpunkArmory/Andacious) — GPL-3.0; used as the Android/Linux compatibility layer.

This repository is an independent community project and is not affiliated with or endorsed by Audacity or Muse Group.
