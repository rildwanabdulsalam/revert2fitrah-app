# Firebase setup — console steps

The app is fully wired for Firebase Auth (email/password) and Cloud
Firestore. It detects whether real Firebase config is present:

- `lib/firebase_options.dart` still has placeholder values → the app runs on
  the on-device mock auth (exactly as before).
- Real values in place → it automatically uses Firebase Auth and mirrors each
  user's progress/preferences to Firestore at `users/{uid}`.

Everything below happens on your side (Google account required); no code
changes are needed.

## 1. Create the project

1. Go to https://console.firebase.google.com → **Add project**.
2. Name it (e.g. `revert2fitrah`). Google Analytics is optional — fine to
   leave off for now.
3. **Pricing tier**: the default **Spark (free)** plan is all Phase 1 needs —
   50k Firestore reads/day and unlimited email/password auth. No card
   required. Upgrade to Blaze only when you later need Cloud Functions or
   overflow the free quota.

## 2. Enable Authentication

1. Build → **Authentication** → Get started.
2. Sign-in method → enable **Email/Password** (just the first toggle;
   leave "Email link (passwordless)" off).
3. Leave Google/Apple providers off for now — the UI already says
   "coming soon". (When you do add Apple later, note Apple requires it for
   App Store release if any third-party login is offered.)
4. Optional but recommended: Settings → **User actions** → keep
   "Email enumeration protection" enabled (default).

## 3. Create the Firestore database

1. Build → **Firestore Database** → Create database.
2. Choose a location near your users (e.g. `europe-west2` or `us-central1`
   — it cannot be changed later).
3. Start in **production mode** (locked), then replace the rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Each signed-in user can read and write only their own document.
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
    // Everything else is denied by default.
  }
}
```

Sanity checks: there is no public read anywhere; no collection other than
`users` is reachable; a user can never address another user's `uid`.

## 4. Register the apps and generate config

From the repo root, with the [Firebase CLI](https://firebase.google.com/docs/cli)
and FlutterFire CLI installed:

```sh
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

Pick your new project and select the android, ios, and web platforms. This
overwrites `lib/firebase_options.dart` with real values — that file is the
only thing the app needs; Dart-only initialization is used, so no
`google-services.json` / `GoogleService-Info.plist` gradle/pod wiring is
required.

Commit the regenerated `firebase_options.dart`. (The values in it are app
identifiers, not secrets — security comes from the Firestore rules and Auth,
not from hiding the config.)

## 5. Verify

```sh
flutter run
```

Create an account in the app, then check the console: the user appears under
Authentication → Users, and after toggling a setting or advancing a lesson, a
`users/{uid}` document appears in Firestore with a `state` map and
`updatedAt` timestamp.

## What syncs

Profile name/email live in Firebase Auth (displayName). The Firestore
`users/{uid}.state` map mirrors: preferences (`pref_*`), Quran reading
position (`quran_surah`, `quran_verse`), lesson progress (`lesson_*`), and
dua reminders (`dua_reminders`). The Quran text cache stays device-local.
Cloud writes are fire-and-forget: if the device is offline, local state is
still saved and the next full push happens at the next sign-in.
