import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:revert2fitrah/services/quran_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

String editionsBody({int verseCount = 2}) {
  List<Map<String, Object>> ayahs(String prefix) => [
        for (var i = 1; i <= verseCount; i++)
          {'numberInSurah': i, 'text': '$prefix $i'},
      ];
  return jsonEncode({
    'code': 200,
    'data': [
      {'edition': 'quran-uthmani', 'ayahs': ayahs('arabic')},
      {'edition': 'en.sahih', 'ayahs': ayahs('translation')},
      {'edition': 'en.transliteration', 'ayahs': ayahs('transliteration')},
    ],
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('global ayah numbering matches known anchors', () {
    // Ayat al-Kursi (2:255) is the 262nd ayah of the Quran (7 + 255).
    expect(globalAyahNumber(1, 1), 1);
    expect(globalAyahNumber(2, 255), 262);
    // Last ayah of the Quran (114:6) is 6236.
    expect(globalAyahNumber(114, 6), 6236);
  });

  test('verse audio URL points at the Alafasy CDN files', () {
    expect(
      verseAudioUrl(2, 255),
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/262.mp3',
    );
  });

  test('parses the editions payload into verses', () {
    final verses = QuranApiService.parseEditionsResponse(editionsBody());
    expect(verses.length, 2);
    expect(verses.first.number, 1);
    expect(verses.first.arabic, 'arabic 1');
    expect(verses.first.translation, 'translation 1');
    expect(verses.first.transliteration, 'transliteration 1');
  });

  test('fetches once and serves later reads from the cache', () async {
    var requests = 0;
    final client = MockClient((request) async {
      requests++;
      expect(
        request.url.toString(),
        'https://api.alquran.cloud/v1/surah/36/editions/'
        'quran-uthmani,en.sahih,en.transliteration',
      );
      return http.Response(
        editionsBody(verseCount: 3),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final prefs = await SharedPreferences.getInstance();
    final api = QuranApiService(prefs, client: client);

    final first = await api.fetchSurah(36);
    expect(first.length, 3);
    expect(requests, 1);

    // Second call is served from cache — even by a fresh instance with a
    // failing client (i.e. offline).
    final offlineApi = QuranApiService(
      prefs,
      client: MockClient((_) async => http.Response('down', 500)),
    );
    final second = await offlineApi.fetchSurah(36);
    expect(second.length, 3);
    expect(second[2].arabic, 'arabic 3');
    expect(requests, 1);
  });

  test('surfaces a friendly error on a failed response', () async {
    final prefs = await SharedPreferences.getInstance();
    final api = QuranApiService(
      prefs,
      client: MockClient((_) async => http.Response('oops', 503)),
    );
    expect(api.fetchSurah(36), throwsA(isA<QuranApiException>()));
  });
}
