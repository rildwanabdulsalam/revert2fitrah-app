# Revert2Fitrah

A gentle companion for the journey home — prayer, Quran, and answers, at your
own pace. Flutter app, Phase 1 (v0.1).

## What's inside

Five tabs behind a floating pill nav, plus onboarding and auth:

- **Onboarding** — 3-page welcome on the deep-green arch-motif hero, leading
  into sign up / log in.
- **Sign up / Log in** — name, email, password with validation. Auth is a
  local mock behind the `AuthService` interface (`lib/state/app_state.dart`);
  Firebase Auth plugs in behind the same seam.
- **Home** — profile, reminder toggles (prayer times, Dua of the Day), reading
  preferences (transliteration, dark mode, language), account row, sign out.
- **Quran** — searchable list of all 114 surahs, "continue reading" card, and
  a verse reader with transliteration, translation, adjustable text size
  ("Aa"), and a simulated audio bar with playback speed.
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

## Placeholder content — read before shipping

Per the Phase 1 spec, several content sets are **placeholders pending the
vetted, licensed dataset and scholar review**:

- Quran text: only Al-Fatihah, Al-Mulk, and Al-Ikhlas ship as samples
  (`lib/data/verses.dart`, generated from the public
  [quran-json](https://github.com/risan/quran-json) dataset). Other surahs
  show a "text coming soon" state.
- Audio (recitation, lesson steps, duas) is simulated or stubbed.
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
