/// Canned responder for the Ask tab. Phase 1 ships warm, pre-written answers
/// keyed on simple topics; the real AI backend replaces [answerFor] later.
/// Every answer is guidance, not a fatwa — the UI pins that disclaimer.
library;

const List<String> kStarterPrompts = [
  'How do I perform Wudu?',
  'What do I say before eating?',
  'I feel isolated from my family',
];

class AskAnswer {
  const AskAnswer({required this.text, this.sources = const []});

  final String text;
  final List<String> sources;
}

AskAnswer answerFor(String question, {String? name}) {
  final q = question.toLowerCase();
  final salutation = name == null || name.isEmpty ? '' : ', $name';

  if (q.contains('wudu') || q.contains('ablution') || q.contains('wash')) {
    return const AskAnswer(
      text:
          'Wudu is the gentle washing that prepares you for prayer, and it takes about a minute once it becomes familiar. In short: intend it in your heart and say Bismillah, wash your hands, rinse your mouth and nose, wash your face, then your arms to the elbows, wipe over your head and ears, and finish with your feet to the ankles — right side before left. The Solat tab has a full 8-step lesson with each step explained slowly, whenever you are ready.',
      sources: ['Quran 5:6', 'Al-Bukhari 159–164'],
    );
  }

  if (q.contains('eat') || q.contains('food') || q.contains('meal')) {
    return const AskAnswer(
      text:
          'Before eating, simply say "Bismillah" — in the name of Allah. If you only remember partway through the meal, say "Bismillahi awwalahu wa akhirahu" (in the name of Allah at its beginning and its end), and when you finish, thank Him with "Alhamdulillah". You will find both duas with their Arabic, transliteration, and sources in the Meals section of the Duas tab.',
      sources: ['Abu Dawud 3767', 'Al-Bukhari 5376'],
    );
  }

  if (q.contains('arabic') || q.contains('language') || q.contains('english')) {
    return AskAnswer(
      text:
          'What a lovely question to be asking$salutation. The fixed parts of salah — like Al-Fatiha — are recited in Arabic, and it\'s completely okay to learn them slowly, a line at a time. Until then, do your best with what you know. Your personal duas can always be in English; Allah understands every language and every heart.',
      sources: const ['Quran 2:286', 'Muslim 397'],
    );
  }

  if (q.contains('isolat') ||
      q.contains('family') ||
      q.contains('alone') ||
      q.contains('lonely')) {
    return AskAnswer(
      text:
          'That feeling is real, and many reverts carry it quietly — you are not doing anything wrong by feeling it$salutation. Islam asks us to keep honouring our families with patience and kindness, even when they don\'t yet understand our path, and small consistent warmth often softens hearts over time. Alongside that, look for community: a local mosque, revert circles, even one good Muslim friend changes a great deal. And in the low moments, the dua of distress in the Duas tab was made for exactly this. You chose this path with courage; you are not alone on it.',
      sources: const ['Quran 31:15', 'Quran 93:3'],
    );
  }

  if (q.contains('pray') || q.contains('salah') || q.contains('solat')) {
    return const AskAnswer(
      text:
          'Prayer is learned the way anything gentle is learned — one step at a time, with lots of repeating. Start with the Solat tab: it walks each prayer movement by movement, with the words written out in transliteration so you can read as you go. Praying imperfectly while you learn is not just acceptable, it is beloved — the effort of the learner is doubled in reward.',
      sources: ['Al-Bukhari 4937', 'Muslim 798'],
    );
  }

  return AskAnswer(
    text:
        'Thank you for asking$salutation — no question is too small here. In Phase 1 I have a small set of prepared answers about wudu, prayer, duas for meals, and finding your feet as a revert; try one of those topics, or one of the suggested questions above. For anything personal or specific, a qualified scholar or imam will always serve you better than an app can.',
    sources: const [],
  );
}
