import 'models.dart';

/// Step-by-step lessons. Posture illustrations are placeholders — real
/// photography/illustration is supplied and scholar-reviewed before release.

const Lesson kWuduLesson = Lesson(
  id: 'wudu',
  title: 'Wudu',
  steps: [
    LessonStep(
      posture: 'NIYYAH · INTENTION',
      title: 'Begin with intention',
      body:
          'Wudu starts in the heart. Quietly intend that this washing is for prayer, then say "Bismillah" — in the name of Allah. No special words are required for the intention itself.',
      illustrationLabel: 'illustration: intention + bismillah',
      recitation: Recitation(
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah',
        translation: 'In the name of Allah.',
      ),
    ),
    LessonStep(
      posture: 'HANDS',
      title: 'Wash your hands',
      body:
          'Wash both hands up to the wrists three times, starting with the right. Let the water reach between the fingers.',
      illustrationLabel: 'illustration: washing hands to the wrists',
    ),
    LessonStep(
      posture: 'MOUTH',
      title: 'Rinse your mouth',
      body:
          'Take a small handful of water and rinse your mouth three times. Gently is fine — this is a washing, not a chore.',
      illustrationLabel: 'illustration: rinsing the mouth',
    ),
    LessonStep(
      posture: 'NOSE',
      title: 'Rinse your nose',
      body:
          'Sniff a little water into the nostrils and blow it out, three times, using the left hand to clear the nose.',
      illustrationLabel: 'illustration: rinsing the nose',
    ),
    LessonStep(
      posture: 'FACE',
      title: 'Wash your face',
      body:
          'Wash the whole face three times — from the hairline to the chin, and from ear to ear.',
      illustrationLabel: 'illustration: washing the face',
    ),
    LessonStep(
      posture: 'ARMS',
      title: 'Wash your arms',
      body:
          'Wash the right arm from fingertips to just above the elbow three times, then the left. Every part should be touched by water.',
      illustrationLabel: 'illustration: washing arms to the elbows',
    ),
    LessonStep(
      posture: 'HEAD & EARS',
      title: 'Wipe your head and ears',
      body:
          'With wet hands, wipe over your head from front to back once, then wipe the inside and back of the ears with your fingers.',
      illustrationLabel: 'illustration: wiping head and ears',
    ),
    LessonStep(
      posture: 'FEET',
      title: 'Wash your feet',
      body:
          'Wash the right foot up to the ankle three times, then the left — between the toes too. Your wudu is complete. Many finish with the shahada, and Jannah\'s eight gates are described as opening for the one who does.',
      illustrationLabel: 'illustration: washing feet to the ankles',
      recitation: Recitation(
        arabic:
            'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
        transliteration:
            'Ash-hadu an la ilaha illallah, wa ash-hadu anna Muhammadan \'abduhu wa rasuluh.',
        translation:
            'I bear witness that there is no god but Allah, and I bear witness that Muhammad is His servant and messenger.',
      ),
    ),
  ],
);

/// The shared salah storyboard, personalised per prayer. Phase 1 teaches the
/// same 10 core movements for every prayer; rak\'ah counts differ per prayer.
Lesson salahLesson(Prayer prayer) {
  return Lesson(
    id: prayer.id,
    title: prayer.name,
    steps: [
      LessonStep(
        posture: 'NIYYAH · INTENTION',
        title: 'Stand with intention',
        body:
            'Face the qibla and quietly intend to pray ${prayer.name} — ${prayer.rakah} rak\'ah. The intention lives in the heart; nothing needs to be said aloud.',
        illustrationLabel: 'illustration: standing, facing qibla',
      ),
      LessonStep(
        posture: 'TAKBIR · OPENING',
        title: 'Allahu Akbar',
        body:
            'Raise your hands to your shoulders or ears and say the opening takbir. With those words, everything else is set aside — you are now in prayer.',
        illustrationLabel: 'illustration: hands raised for takbir',
        recitation: Recitation(
          arabic: 'اللَّهُ أَكْبَرُ',
          transliteration: 'Allahu Akbar',
          translation: 'Allah is the Greatest.',
        ),
      ),
      LessonStep(
        posture: 'QIYAM · STANDING',
        title: 'Recite Al-Fatiha',
        body:
            'Standing calmly, hands folded, recite the opening chapter. Slowly is beautiful — one line at a time is enough while you learn.',
        illustrationLabel: 'illustration: standing posture (qiyam)',
        recitation: Recitation(
          arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          transliteration: 'Bismillahir-rahmanir-rahim',
          translation:
              'In the name of Allah, the Most Gracious, the Most Merciful.',
        ),
      ),
      LessonStep(
        posture: 'RUKU · BOWING',
        title: 'Ruku — bowing',
        body:
            'Say "Allahu Akbar" and bow with your back straight and hands on your knees. In this position, glorify your Lord three times.',
        illustrationLabel: 'illustration: bowing posture (ruku)',
        recitation: Recitation(
          arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
          transliteration: 'Subhana rabbiyal-\'azim',
          translation: 'Glory to my Lord, the Magnificent.',
        ),
      ),
      LessonStep(
        posture: 'I\'TIDAL · RISING',
        title: 'Stand back up',
        body:
            'Rise from bowing and stand tall again, saying that Allah hears the one who praises Him — then answer with praise.',
        illustrationLabel: 'illustration: standing after ruku',
        recitation: Recitation(
          arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ ، رَبَّنَا وَلَكَ الْحَمْدُ',
          transliteration: 'Sami\'allahu liman hamidah, rabbana wa lakal-hamd',
          translation:
              'Allah hears the one who praises Him. Our Lord, to You belongs all praise.',
        ),
      ),
      LessonStep(
        posture: 'SUJUD · PROSTRATION',
        title: 'Sujud — prostration',
        body:
            'Say "Allahu Akbar" and lower yourself to the ground: forehead, nose, palms, knees, and toes touching the floor. This is the closest a servant is to their Lord.',
        illustrationLabel: 'illustration: prostration (sujud)',
        recitation: Recitation(
          arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
          transliteration: 'Subhana rabbiyal-a\'la',
          translation: 'Glory to my Lord, the Most High.',
        ),
      ),
      LessonStep(
        posture: 'JALSA · SITTING',
        title: 'Sit between prostrations',
        body:
            'Rise to a calm sitting position on your left leg and ask for forgiveness before the second sujud.',
        illustrationLabel: 'illustration: sitting between sujud',
        recitation: Recitation(
          arabic: 'رَبِّ اغْفِرْ لِي',
          transliteration: 'Rabbighfir li',
          translation: 'My Lord, forgive me.',
        ),
      ),
      LessonStep(
        posture: 'SUJUD · SECOND',
        title: 'Second sujud, then rise',
        body:
            'Prostrate a second time exactly as before. That completes one rak\'ah — stand and repeat from Al-Fatiha until all ${prayer.rakah} rak\'ah of ${prayer.name} are done.',
        illustrationLabel: 'illustration: second prostration',
      ),
      LessonStep(
        posture: 'TASHAHHUD · SITTING',
        title: 'The tashahhud',
        body:
            'In the final sitting, recite the tashahhud — the greeting of the prayer. Read it from the transliteration for now; it becomes memory faster than you expect.',
        illustrationLabel: 'illustration: final sitting (tashahhud)',
        recitation: Recitation(
          arabic: 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ',
          transliteration: 'At-tahiyyatu lillahi was-salawatu wat-tayyibat…',
          translation:
              'All greetings, prayers, and pure words are for Allah…',
        ),
      ),
      LessonStep(
        posture: 'TASLEEM · CLOSING',
        title: 'Tasleem — the closing',
        body:
            'Turn your face to the right and then to the left, greeting with salam each time. Your prayer is complete — well done. Every prayer you pray teaches the next one.',
        illustrationLabel: 'illustration: tasleem to the right',
        recitation: Recitation(
          arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
          transliteration: 'As-salamu \'alaykum wa rahmatullah',
          translation: 'Peace be upon you, and the mercy of Allah.',
        ),
      ),
    ],
  );
}
