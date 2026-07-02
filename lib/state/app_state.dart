import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/duas.dart';
import '../firebase_options.dart';
import '../services/auth_service.dart';
import '../services/cloud_store.dart';

/// Pref keys mirrored to Firestore when Firebase is configured. Everything
/// else (e.g. the Quran text cache) stays device-local.
const _syncedKeyPrefixes = ['pref.', 'quran.surah', 'quran.verse', 'lesson.', 'dua.reminders'];

bool _isSynced(String key) =>
    _syncedKeyPrefixes.any((prefix) => key.startsWith(prefix));

class AppState extends ChangeNotifier {
  AppState._(this._prefs, this.auth, this._cloud);

  static Future<AppState> load({
    AuthService? authOverride,
    CloudStore? cloudOverride,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    AuthService auth;
    CloudStore? cloud = cloudOverride;
    if (authOverride != null) {
      auth = authOverride;
    } else if (await _initFirebase()) {
      auth = FirebaseAuthService(fb.FirebaseAuth.instance);
      cloud ??= FirestoreCloudStore(FirebaseFirestore.instance);
    } else {
      auth = LocalAuthService(prefs);
    }

    final state = AppState._(prefs, auth, cloud);
    await state._restoreSession();
    return state;
  }

  /// Initializes Firebase when real options are present; the checked-in
  /// firebase_options.dart is a placeholder until `flutterfire configure`
  /// runs (see FIREBASE_SETUP.md).
  static Future<bool> _initFirebase() async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.apiKey.startsWith('REPLACE')) return false;
    try {
      await Firebase.initializeApp(options: options);
      return true;
    } catch (e) {
      debugPrint('Firebase init failed, using on-device auth: $e');
      return false;
    }
  }

  final SharedPreferences _prefs;
  final AuthService auth;
  final CloudStore? _cloud;

  AuthUser? _user;

  // ---- Auth / profile ----
  bool get isSignedIn => _user != null;
  String get userName => _user?.name ?? '';
  String get userEmail => _user?.email ?? '';

  Future<void> _restoreSession() async {
    _user = auth.currentUser;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = await auth.signUp(name: name, email: email, password: password);
    await _pushAllToCloud();
    notifyListeners();
  }

  Future<void> logIn({required String email, required String password}) async {
    _user = await auth.logIn(email: email, password: password);
    await _pullFromCloud();
    notifyListeners();
  }

  Future<void> signOut() async {
    await auth.signOut();
    _user = null;
    notifyListeners();
  }

  // ---- Cloud mirroring ----
  Future<void> _pullFromCloud() async {
    final cloud = _cloud;
    final user = _user;
    if (cloud == null || user == null) return;
    try {
      final state = await cloud.load(user.uid);
      if (state == null) return;
      for (final entry in state.entries) {
        final key = entry.key;
        final value = entry.value;
        if (!_isSynced(key)) continue;
        switch (value) {
          case bool v:
            await _prefs.setBool(key, v);
          case int v:
            await _prefs.setInt(key, v);
          case String v:
            await _prefs.setString(key, v);
          case List<dynamic> v:
            await _prefs.setStringList(key, v.cast<String>());
          default:
            break;
        }
      }
    } catch (e) {
      debugPrint('Cloud pull failed (continuing with local state): $e');
    }
  }

  Future<void> _pushAllToCloud() async {
    final cloud = _cloud;
    final user = _user;
    if (cloud == null || user == null) return;
    final state = <String, Object?>{
      for (final key in _prefs.getKeys())
        if (_isSynced(key)) key: _prefs.get(key),
    };
    try {
      await cloud.save(user.uid, state);
    } catch (e) {
      debugPrint('Cloud push failed (state kept locally): $e');
    }
  }

  void _mirror(String key, Object value) {
    final cloud = _cloud;
    final user = _user;
    if (cloud == null || user == null || !_isSynced(key)) return;
    cloud.save(user.uid, {key: value}).catchError((Object e) {
      debugPrint('Cloud mirror failed for $key (state kept locally): $e');
    });
  }

  // ---- Preferences ----
  bool get prayerReminders => _prefs.getBool('pref.prayerReminders') ?? true;
  bool get duaOfDayReminder => _prefs.getBool('pref.duaOfDay') ?? true;
  bool get transliteration => _prefs.getBool('pref.transliteration') ?? true;
  bool get darkMode => _prefs.getBool('pref.darkMode') ?? false;
  String get language => _prefs.getString('pref.language') ?? 'English';

  Future<void> _setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
    _mirror(key, value);
    notifyListeners();
  }

  Future<void> setPrayerReminders(bool v) => _setBool('pref.prayerReminders', v);
  Future<void> setDuaOfDayReminder(bool v) => _setBool('pref.duaOfDay', v);
  Future<void> setTransliteration(bool v) => _setBool('pref.transliteration', v);
  Future<void> setDarkMode(bool v) => _setBool('pref.darkMode', v);

  // ---- Quran: continue reading ----
  int get readingSurah => _prefs.getInt('quran.surah') ?? 67;
  int get readingVerse => _prefs.getInt('quran.verse') ?? 12;

  Future<void> setReadingPosition(int surah, int verse) async {
    await _prefs.setInt('quran.surah', surah);
    await _prefs.setInt('quran.verse', verse);
    _mirror('quran.surah', surah);
    _mirror('quran.verse', verse);
    notifyListeners();
  }

  // ---- Lessons ----
  /// 1-based step the learner is on; 0 means not started. Dhuhr starts
  /// mid-lesson so a fresh install matches the Phase 1 demo state.
  int lessonStep(String lessonId) =>
      _prefs.getInt('lesson.step.$lessonId') ?? (lessonId == 'dhuhr' ? 3 : 0);
  bool lessonLearned(String lessonId) =>
      _prefs.getBool('lesson.done.$lessonId') ?? lessonId == 'fajr';

  Future<void> setLessonStep(String lessonId, int step) async {
    await _prefs.setInt('lesson.step.$lessonId', step);
    _mirror('lesson.step.$lessonId', step);
    notifyListeners();
  }

  Future<void> markLessonLearned(String lessonId) async {
    await _prefs.setBool('lesson.done.$lessonId', true);
    _mirror('lesson.done.$lessonId', true);
    notifyListeners();
  }

  // ---- Duas ----
  /// Today's featured dua, rotated daily through the morning set.
  String get todaysDuaId {
    final morning = kDuaCategories.first.duas;
    final day = DateTime.now().difference(DateTime(2026)).inDays;
    return morning[(day % morning.length + morning.length) % morning.length].id;
  }

  bool duaReminderSet(String duaId) =>
      (_prefs.getStringList('dua.reminders') ?? const []).contains(duaId);

  Future<void> toggleDuaReminder(String duaId) async {
    final current = _prefs.getStringList('dua.reminders') ?? <String>[];
    if (current.contains(duaId)) {
      current.remove(duaId);
    } else {
      current.add(duaId);
    }
    await _prefs.setStringList('dua.reminders', current);
    _mirror('dua.reminders', current);
    notifyListeners();
  }
}
