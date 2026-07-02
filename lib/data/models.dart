/// Plain data models for the Phase 1 content set.
library;

class Surah {
  const Surah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.verseCount,
    required this.revelation,
  });

  final int number;
  final String name;
  final String arabicName;
  final String meaning;
  final int verseCount;
  final String revelation;
}

class Verse {
  const Verse({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  final int number;
  final String arabic;
  final String transliteration;
  final String translation;
}

class Dua {
  const Dua({
    required this.id,
    required this.title,
    required this.occasion,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    this.tip,
  });

  final String id;
  final String title;

  /// When it is said — shown under the title on the detail screen.
  final String occasion;
  final String arabic;
  final String transliteration;
  final String translation;

  /// e.g. "Al-Bukhari 6312".
  final String source;

  /// Gentle encouragement shown at the bottom of the detail screen.
  final String? tip;
}

class DuaCategory {
  const DuaCategory({required this.name, required this.duas});

  final String name;
  final List<Dua> duas;
}

/// One recitation shown inside a lesson step (Arabic + helps).
class Recitation {
  const Recitation({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  final String arabic;
  final String transliteration;
  final String translation;
}

class LessonStep {
  const LessonStep({
    required this.posture,
    required this.title,
    required this.body,
    required this.illustrationLabel,
    this.recitation,
  });

  /// Overline, e.g. "QIYAM · STANDING".
  final String posture;
  final String title;
  final String body;

  /// Placeholder label until real photography/illustration is supplied
  /// and scholar-reviewed.
  final String illustrationLabel;
  final Recitation? recitation;
}

class Lesson {
  const Lesson({required this.id, required this.title, required this.steps});

  final String id;
  final String title;
  final List<LessonStep> steps;
}

class Prayer {
  const Prayer({
    required this.id,
    required this.name,
    required this.rakah,
    required this.timeOfDay,
  });

  final String id;
  final String name;
  final int rakah;

  /// e.g. "dawn", "afternoon".
  final String timeOfDay;
}
