# Revert2Fitrah

A gentle companion for the journey home — prayer, Quran, and answers, at your
own pace. Flutter app, Phase 1 (v0.1).

## What's inside

Five tabs behind a floating pill nav, plus onboarding and auth:

- **Onboarding** — 3-page welcome on the deep-green arch-motif hero, leading
  into sign up / log in.
- **Sign up / Log in** — name, email, password with validation and friendly
  error states. Firebase Auth (email/password) with Firestore state sync is
  fully wired; until `flutterfire configure` supplies real config the app
  runs on an on-device mock behind the same `AuthService` seam
  (`lib/services/auth_service.dart`). Console setup: see FIREBASE_SETUP.md.
- **Home** — profile, reminder toggles (prayer times, Dua of the Day), reading
  preferences (transliteration, dark mode, language), account row, sign out.
- **Quran** — searchable list of all 114 surahs, "continue reading" card, and
  a verse reader with transliteration, translation, adjustable text size
  ("Aa"), and per-verse recitation audio with speed control. Al-Fatihah,
  Al-Mulk, and Al-Ikhlas are bundled for offline/instant use; every other
  surah is fetched once from the Al Quran Cloud API and cached on device
  (`lib/services/quran_api.dart`). Audio streams from the same project's CDN
  (Mishary Rashid Alafasy, 128kbps) and auto-advances verse by verse.
- **Solat** — the five daily prayers with rak'ah counts and learning state,
  the Wudu lesson (8 steps) as the "start here" card, and a step-by-step
  lesson player (10 steps per prayer) with segmented progress, posture
  overlines, and recitation cards.
- **Duas** — Morning / Evening / Travel / Distress / Meals categories, each
  dua with Arabic, transliteration, translation, hadith source, and a gentle
  tip; "Today's dua" rotates daily; per-dua reminder toggle.
- **Ask** — chat with starter prompts and warm, pre-written answers. Every
  answer carries the "guidance, not a fatwa" strip per spec.

State (profile, preferences, reading position, lesson progress, reminders)
persists locally via `shared_preferences`. Dark mode is a full theme pass.

## Design system

Tokens live in `lib/theme/app_theme.dart`: warm white ground `#F7F3EA`, deep
green `#16624C`, gold `#D9A521` for "now/next" and sacred markers, white cards
at r20–26, floating pill nav. Type: Lora (display), Inter (UI), Amiri
(Arabic) — all bundled under `assets/fonts` (SIL Open Font License).

## Content status

Live now:

- Quran text, translation (Saheeh International), transliteration, and
  recitation audio come from the [Al Quran Cloud](https://alquran.cloud/api)
  API/CDN, cached per surah after first fetch. Three surahs are also bundled
  for offline use (`lib/data/verses.dart`).
- Auth + cloud sync via Firebase once configured (FIREBASE_SETUP.md).

Still **placeholder pending vetted sources and scholar review** (per the
Phase 1 plan):

- Duas and Solat lesson content (text ships in-app but awaits review;
  step/dua audio is stubbed).
- Lesson posture illustrations are hatched placeholders awaiting real,
  scholar-reviewed photography/illustration.
- Prayer times are static hints; a location-aware calculation engine is
  Phase 2.
- Ask answers are canned (`lib/data/ask_responses.dart`) until the AI backend
  is wired in.

## Running

```sh
flutter pub get
flutter run            # Android / iOS / web
flutter test           # smoke + content tests
```

The web build serves CanvasKit from the app's own origin (see
`web/flutter_bootstrap.js`), so it works behind restricted networks.

**Web release builds: run `flutter clean` first** after any change to the
plugin set in `pubspec.yaml`. `flutter build web` can reuse a cached
`web_plugin_registrant.dart`, which silently drops newly-added web plugins
(e.g. `firebase_core_web`) from the bundle — the app then falls back to the
native method channel and Firebase fails to initialize in the browser:

```sh
flutter clean && flutter pub get && flutter build web --release
```
