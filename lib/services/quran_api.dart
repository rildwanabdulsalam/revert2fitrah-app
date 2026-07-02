import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';
import '../data/surahs.dart';

/// Quran content client backed by the Al Quran Cloud API
/// (https://alquran.cloud/api — free, no key required).
///
/// One request per surah returns Arabic (Uthmani script), the Saheeh
/// International translation, and transliteration. Fetched surahs are cached
/// in SharedPreferences so each is downloaded once.
class QuranApiService {
  QuranApiService(this._prefs, {http.Client? client})
    : _client = client ?? http.Client();

  static const _base = 'https://api.alquran.cloud/v1';
  static const _editions = 'quran-uthmani,en.sahih,en.transliteration';
  static const _cachePrefix = 'quran.cache.v1.';

  final SharedPreferences _prefs;
  final http.Client _client;
  final _memory = <int, List<Verse>>{};

  Future<List<Verse>> fetchSurah(int surahNumber) async {
    final cached = _memory[surahNumber] ?? _readCache(surahNumber);
    if (cached != null) {
      _memory[surahNumber] = cached;
      return cached;
    }

    final uri = Uri.parse('$_base/surah/$surahNumber/editions/$_editions');
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw QuranApiException(
        'The Quran service replied with status ${response.statusCode}.',
      );
    }

    final verses = parseEditionsResponse(response.body);
    _memory[surahNumber] = verses;
    await _writeCache(surahNumber, verses);
    return verses;
  }

  /// Parses the /surah/{n}/editions payload: `data` is a list of the same
  /// surah in each requested edition, in request order.
  static List<Verse> parseEditionsResponse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final editions = json['data'] as List<dynamic>;
    if (editions.length < 3) {
      throw const QuranApiException('Unexpected response from Quran service.');
    }
    List<dynamic> ayahsOf(int i) =>
        (editions[i] as Map<String, dynamic>)['ayahs'] as List<dynamic>;
    final arabic = ayahsOf(0);
    final translation = ayahsOf(1);
    final transliteration = ayahsOf(2);

    return [
      for (var i = 0; i < arabic.length; i++)
        Verse(
          number: (arabic[i] as Map<String, dynamic>)['numberInSurah'] as int,
          arabic: (arabic[i] as Map<String, dynamic>)['text'] as String,
          translation:
              (translation[i] as Map<String, dynamic>)['text'] as String,
          transliteration:
              (transliteration[i] as Map<String, dynamic>)['text'] as String,
        ),
    ];
  }

  List<Verse>? _readCache(int surahNumber) {
    final raw = _prefs.getString('$_cachePrefix$surahNumber');
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in list.cast<Map<String, dynamic>>())
          Verse(
            number: item['n'] as int,
            arabic: item['a'] as String,
            transliteration: item['tl'] as String,
            translation: item['tr'] as String,
          ),
      ];
    } catch (_) {
      return null; // Corrupt cache entry — refetch.
    }
  }

  Future<void> _writeCache(int surahNumber, List<Verse> verses) {
    final raw = jsonEncode([
      for (final v in verses)
        {
          'n': v.number,
          'a': v.arabic,
          'tl': v.transliteration,
          'tr': v.translation,
        },
    ]);
    return _prefs.setString('$_cachePrefix$surahNumber', raw);
  }
}

class QuranApiException implements Exception {
  const QuranApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Global ayah number (1–6236) for a verse, from the surah metadata.
int globalAyahNumber(int surahNumber, int verseNumber) {
  var offset = 0;
  for (final surah in kSurahs) {
    if (surah.number == surahNumber) break;
    offset += surah.verseCount;
  }
  return offset + verseNumber;
}

/// Per-verse recitation audio from the Al Quran Cloud CDN.
/// Default reciter: Mishary Rashid Alafasy at 128kbps.
String verseAudioUrl(
  int surahNumber,
  int verseNumber, {
  String reciter = 'ar.alafasy',
  int bitrate = 128,
}) {
  final ayah = globalAyahNumber(surahNumber, verseNumber);
  return 'https://cdn.islamic.network/quran/audio/$bitrate/$reciter/$ayah.mp3';
}
