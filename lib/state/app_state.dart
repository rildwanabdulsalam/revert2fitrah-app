import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/duas.dart';

/// Auth seam for Phase 1. The local implementation stores the profile on
/// device; swap in a Firebase Auth implementation behind this same interface
/// when the backend is wired up.
abstract class AuthService {
  Future<void> signUp({required String name, required String email});
  Future<void> logIn({required String email});
  Future<void> signOut();
}

class _LocalAuthService implements AuthService {
  _LocalAuthService(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> signUp({required String name, required String email}) async {
    await _prefs.setString('user.name', name);
    await _prefs.setString('user.email', email);
  }

  @override
  Future<void> logIn({required String email}) async {
    await _prefs.setString('user.email', email);
    if ((_prefs.getString('user.name') ?? '').isEmpty) {
      final guess = email.split('@').first;
      await _prefs.setString(
        'user.name',
        guess.isEmpty
            ? 'Friend'
            : guess[0].toUpperCase() + guess.substring(1),
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove('user.name');
    await _prefs.remove('user.email');
  }
}

class AppState extends ChangeNotifier {
  AppState._(this._prefs) : auth = _LocalAuthService(_prefs);

  static Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppState._(prefs);
  }

  final SharedPreferences _prefs;
  final AuthService auth;

  // ---- Auth / profile ----
  bool get isSignedIn => (_prefs.getString('user.email') ?? '').isNotEmpty;
  String get userName => _prefs.getString('user.name') ?? '';
  String get userEmail => _prefs.getString('user.email') ?? '';

  Future<void> signUp({required String name, required String email}) async {
    await auth.signUp(name: name, email: email);
    notifyListeners();
  }

  Future<void> logIn({required String email}) async {
    await auth.logIn(email: email);
    notifyListeners();
  }

  Future<void> signOut() async {
    await auth.signOut();
    notifyListeners();
  }

  // ---- Preferences ----
  bool get prayerReminders => _prefs.getBool('pref.prayerReminders') ?? true;
  bool get duaOfDayReminder => _prefs.getBool('pref.duaOfDay') ?? true;
  bool get transliteration => _prefs.getBool('pref.transliteration') ?? true;
  bool get darkMode => _prefs.getBool('pref.darkMode') ?? false;
  String get language => _prefs.getString('pref.language') ?? 'English';

  Future<void> _setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
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
    notifyListeners();
  }

  Future<void> markLessonLearned(String lessonId) async {
    await _prefs.setBool('lesson.done.$lessonId', true);
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
    notifyListeners();
  }
}
