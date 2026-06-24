# ShadowLang

Desktop-first Flutter MVP for language learning through subtitles, vocabulary tracking, and shadowing.

## Run

This workspace currently prioritizes desktop testing and uses mock audio/player and mock Gemini services.

## Lightest Path: GitHub Pages

If you want to avoid installing Flutter and Visual Studio locally, push this repo to GitHub and enable Pages:

1. Open the GitHub repo settings.
2. Go to Pages.
3. Set Source to GitHub Actions.
4. Push to `main`, or manually run the `Deploy Flutter Web` workflow.

The workflow installs Flutter in GitHub Actions, creates the web runner, runs tests, builds the app, and deploys `build/web` to GitHub Pages.

This is the lightest testing path for now because your computer only needs Git/GitHub access.

## Desktop Run

```powershell
flutter pub get
flutter create --platforms=windows .
flutter run -d windows
```

On macOS:

```bash
flutter pub get
flutter create --platforms=macos .
flutter run -d macos
```

If `windows/` or `macos/` already exists, the `flutter create` command refreshes missing runner files without changing the app code under `lib/`.

## MVP Scope

- Material 3 Flutter UI.
- Riverpod feature state.
- Mock content seed data.
- Mock playback clock with subtitle sync and seek.
- Vocabulary status: unknown, learning, known.
- Mock Gemini translation and shadowing feedback services.
- Drift dependency is included for the later persistent SQLite implementation, while the current desktop MVP keeps storage in memory to avoid early plugin/codegen friction.
