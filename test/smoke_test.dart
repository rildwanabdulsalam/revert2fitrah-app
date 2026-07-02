import 'package:flutter_test/flutter_test.dart';
import 'package:revert2fitrah/data/duas.dart';
import 'package:revert2fitrah/data/lessons.dart';
import 'package:revert2fitrah/data/prayers.dart';
import 'package:revert2fitrah/data/surahs.dart';
import 'package:revert2fitrah/data/verses.dart';
import 'package:revert2fitrah/main.dart';
import 'package:revert2fitrah/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('content set is complete', () {
    expect(kSurahs.length, 114);
    expect(kSurahs.first.name, 'Al-Fatihah');
    expect(kSurahs[66].name, 'Al-Mulk');
    expect(kSampleVerses[1]!.length, 7);
    expect(kSampleVerses[67]!.length, 30);
    expect(kSampleVerses[112]!.length, 4);
    expect(kPrayers.length, 5);
    expect(kWuduLesson.steps.length, 8);
    expect(salahLesson(prayerById('dhuhr')).steps.length, 10);
    expect(kDuaCategories.map((c) => c.name), [
      'Morning',
      'Evening',
      'Travel',
      'Distress',
      'Meals',
    ]);
    expect(kDuaCategories.first.duas.length, 8);
  });

  testWidgets('signed-out launch shows onboarding', (tester) async {
    final state = await AppState.load();
    await tester.pumpWidget(Revert2FitrahApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Revert2Fitrah'), findsOneWidget);
    expect(find.text('Begin your journey'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });

  testWidgets('signed-in launch shows the shell and tabs work', (tester) async {
    SharedPreferences.setMockInitialValues({
      'user.name': 'Amina',
      'user.email': 'amina@example.com',
    });
    final state = await AppState.load();
    await tester.pumpWidget(Revert2FitrahApp(state: state));
    await tester.pumpAndSettle();

    // Home tab: profile + settings.
    expect(find.text('Amina'), findsWidgets);
    expect(find.text('Prayer time reminders'), findsOneWidget);

    await tester.tap(find.text('Quran'));
    await tester.pumpAndSettle();
    expect(find.text('Search surahs…'), findsOneWidget);
    expect(find.textContaining('Al-Mulk · verse'), findsOneWidget);

    await tester.tap(find.text('Solat'));
    await tester.pumpAndSettle();
    expect(find.text('Solat Guide'), findsOneWidget);
    expect(find.text('Wudu — washing before prayer'), findsOneWidget);

    await tester.tap(find.text('Duas'));
    await tester.pumpAndSettle();
    expect(find.text('Words for every moment — each with its source.'),
        findsOneWidget);

    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    expect(find.text('Guidance · not a fatwa'), findsOneWidget);
    expect(find.text('How do I perform Wudu?'), findsOneWidget);
  });
}
