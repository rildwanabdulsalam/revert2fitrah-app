import 'models.dart';

/// Phase 1 dua library. Texts are standard, widely published adhkar; the
/// Arabic and sources still go through scholar review before release
/// (same review gate as the Quran dataset — see README).
const List<DuaCategory> kDuaCategories = [
  DuaCategory(
    name: 'Morning',
    duas: [
      Dua(
        id: 'morning-waking',
        title: 'Upon waking',
        occasion: 'Said first thing after waking up',
        arabic:
            'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        transliteration:
            'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur.',
        translation:
            'Praise be to Allah who gave us life after death, and to Him is the resurrection.',
        source: 'Al-Bukhari 6312',
        tip:
            'Let this be the very first sentence of your day — even before reaching for your phone.',
      ),
      Dua(
        id: 'morning-remembrance',
        title: 'Morning remembrance',
        occasion: 'Said upon waking or after Fajr',
        arabic:
            'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
        transliteration:
            'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilayka an-nushur.',
        translation:
            'O Allah, by You we enter the morning and by You we enter the evening; by You we live and by You we die, and to You is the resurrection.',
        source: 'At-Tirmidhi 3391',
        tip:
            'Try saying it once slowly with the transliteration — meaning first, memorization later. It will come.',
      ),
      Dua(
        id: 'morning-istighfar',
        title: 'Sayyid al-Istighfar',
        occasion: 'The master supplication for forgiveness',
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
        transliteration:
            'Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana \'abduk, wa ana \'ala \'ahdika wa wa\'dika mastata\'t.',
        translation:
            'O Allah, You are my Lord; there is no god but You. You created me and I am Your servant, and I keep Your covenant and promise as much as I can.',
        source: 'Al-Bukhari 6306',
        tip:
            'The Prophet ﷺ called this the master of seeking forgiveness. One sincere recitation outweighs a hundred rushed ones.',
      ),
      Dua(
        id: 'morning-leaving-home',
        title: 'Leaving the home',
        occasion: 'Said when stepping out of the house',
        arabic:
            'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        transliteration:
            'Bismillahi tawakkaltu \'alallah, wa la hawla wa la quwwata illa billah.',
        translation:
            'In the name of Allah, I place my trust in Allah; there is no power and no strength except with Allah.',
        source: 'Abu Dawud 5095',
        tip: 'A short one — perfect to pair with putting on your shoes.',
      ),
      Dua(
        id: 'morning-day-goodness',
        title: 'Goodness of this day',
        occasion: 'Part of the morning adhkar',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ هَذَا الْيَوْمِ فَتْحَهُ وَنَصْرَهُ وَنُورَهُ وَبَرَكَتَهُ وَهُدَاهُ',
        transliteration:
            'Allahumma inni as\'aluka khayra hadhal-yawm: fathahu wa nasrahu wa nurahu wa barakatahu wa hudah.',
        translation:
            'O Allah, I ask You for the good of this day: its openings, its help, its light, its blessing, and its guidance.',
        source: 'Abu Dawud 5084',
        tip: 'Name the day\'s worries silently as you say it — Allah hears both.',
      ),
      Dua(
        id: 'morning-protection',
        title: 'Protection in His name',
        occasion: 'Said three times, morning and evening',
        arabic:
            'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        transliteration:
            'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa huwas-sami\'ul-\'alim.',
        translation:
            'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing.',
        source: 'At-Tirmidhi 3388',
        tip: 'Said three times — a gentle rhythm to start and close the day.',
      ),
      Dua(
        id: 'morning-contentment',
        title: 'Pleased with Allah',
        occasion: 'Said three times in the morning',
        arabic:
            'رَضِيتُ بِاللَّهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
        transliteration:
            'Raditu billahi rabba, wa bil-islami dina, wa bi-Muhammadin sallallahu \'alayhi wa sallama nabiyya.',
        translation:
            'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad ﷺ as my Prophet.',
        source: 'Abu Dawud 5072',
        tip:
            'For a revert, this one can feel like coming home — it is a quiet renewal of the choice you made.',
      ),
      Dua(
        id: 'morning-knowledge',
        title: 'Beneficial knowledge',
        occasion: 'Said after the Fajr prayer',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا وَعَمَلًا مُتَقَبَّلًا',
        transliteration:
            'Allahumma inni as\'aluka \'ilman nafi\'a, wa rizqan tayyiba, wa \'amalan mutaqabbala.',
        translation:
            'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
        source: 'Ibn Majah 925',
        tip: 'Three asks, one breath — a whole day\'s intention in one line.',
      ),
    ],
  ),
  DuaCategory(
    name: 'Evening',
    duas: [
      Dua(
        id: 'evening-remembrance',
        title: 'Evening remembrance',
        occasion: 'Said after Asr until Maghrib',
        arabic:
            'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
        transliteration:
            'Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namutu, wa ilaykal-masir.',
        translation:
            'O Allah, by You we enter the evening and by You we enter the morning; by You we live and by You we die, and to You is the final return.',
        source: 'At-Tirmidhi 3391',
        tip: 'The evening twin of the morning remembrance — notice the small change at the end.',
      ),
      Dua(
        id: 'evening-before-sleep',
        title: 'Before sleeping',
        occasion: 'Said when lying down to sleep',
        arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        transliteration: 'Bismika Allahumma amutu wa ahya.',
        translation: 'In Your name, O Allah, I die and I live.',
        source: 'Al-Bukhari 6324',
        tip: 'Short enough to say every single night, starting tonight.',
      ),
      Dua(
        id: 'evening-ayat-kursi',
        title: 'Ayat al-Kursi at night',
        occasion: 'Recited before sleeping for protection',
        arabic:
            'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
        transliteration:
            'Allahu la ilaha illa huwal-hayyul-qayyum, la ta\'khudhuhu sinatun wa la nawm…',
        translation:
            'Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep… (Quran 2:255)',
        source: 'Al-Bukhari 2311',
        tip:
            'Whoever recites it before sleeping remains under Allah\'s protection until morning.',
      ),
      Dua(
        id: 'evening-forgiveness',
        title: 'Seeking pardon at night',
        occasion: 'Said in the last part of the day',
        arabic:
            'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
        transliteration: 'Allahumma innaka \'afuwwun tuhibbul-\'afwa fa\'fu \'anni.',
        translation: 'O Allah, You are Pardoning and love pardon, so pardon me.',
        source: 'At-Tirmidhi 3513',
        tip: 'Close the day gently — whatever it held, this is how it ends.',
      ),
    ],
  ),
  DuaCategory(
    name: 'Travel',
    duas: [
      Dua(
        id: 'travel-vehicle',
        title: 'Boarding a vehicle',
        occasion: 'Said when setting out on a journey',
        arabic:
            'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
        transliteration:
            'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun.',
        translation:
            'Glory to Him who has subjected this to us, for we could never have accomplished it ourselves — and to our Lord we are surely returning.',
        source: 'Muslim 1342',
        tip: 'Car, bus, train, or plane — the dua travels with you.',
      ),
      Dua(
        id: 'travel-leaving',
        title: 'Dua of the traveller',
        occasion: 'Said at the start of a journey',
        arabic:
            'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى',
        transliteration:
            'Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa, wa minal-\'amali ma tarda.',
        translation:
            'O Allah, we ask You on this journey of ours for righteousness, mindfulness of You, and deeds that please You.',
        source: 'Muslim 1342',
        tip: 'Travel softens the heart — a good time to ask for what matters.',
      ),
      Dua(
        id: 'travel-entering-town',
        title: 'Entering a new place',
        occasion: 'Said when arriving somewhere new',
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ أَهْلِهَا وَخَيْرَ مَا فِيهَا',
        transliteration:
            'Allahumma inni as\'aluka khayraha wa khayra ahliha wa khayra ma fiha.',
        translation:
            'O Allah, I ask You for the good of this place, the good of its people, and the good of what is in it.',
        source: 'Al-Hakim, graded sahih',
        tip: 'New city, new job, new chapter — this one fits them all.',
      ),
    ],
  ),
  DuaCategory(
    name: 'Distress',
    duas: [
      Dua(
        id: 'distress-yunus',
        title: 'The dua of Yunus',
        occasion: 'Said in hardship and anxiety',
        arabic:
            'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
        transliteration:
            'La ilaha illa anta subhanaka inni kuntu minaz-zalimin.',
        translation:
            'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers. (Quran 21:87)',
        source: 'At-Tirmidhi 3505',
        tip:
            'Said from inside the whale, answered from above the heavens. No situation is too dark for it.',
      ),
      Dua(
        id: 'distress-anxiety',
        title: 'Anxiety and sorrow',
        occasion: 'Said when the heart feels heavy',
        arabic:
            'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَالْعَجْزِ وَالْكَسَلِ',
        transliteration:
            'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wal-\'ajzi wal-kasal.',
        translation:
            'O Allah, I seek refuge in You from worry and grief, from helplessness and laziness.',
        source: 'Al-Bukhari 6369',
        tip: 'Naming the feeling to Allah is already the first step out of it.',
      ),
      Dua(
        id: 'distress-sufficiency',
        title: 'Allah is enough for us',
        occasion: 'Said when facing what feels too big',
        arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
        transliteration: 'Hasbunallahu wa ni\'mal-wakil.',
        translation:
            'Allah is sufficient for us, and He is the best disposer of affairs. (Quran 3:173)',
        source: 'Al-Bukhari 4563',
        tip:
            'The words of Ibrahim in the fire and of the believers before battle. Five words that carry everything.',
      ),
      Dua(
        id: 'distress-relief',
        title: 'No ease but Yours',
        occasion: 'Said when things feel stuck',
        arabic:
            'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
        transliteration:
            'Allahumma la sahla illa ma ja\'altahu sahla, wa anta taj\'alul-hazna idha shi\'ta sahla.',
        translation:
            'O Allah, there is no ease except what You make easy — and You make sorrow easy when You will.',
        source: 'Ibn Hibban 974',
        tip: 'Keep it for exam days, hard conversations, and long nights.',
      ),
    ],
  ),
  DuaCategory(
    name: 'Meals',
    duas: [
      Dua(
        id: 'meals-before',
        title: 'Before eating',
        occasion: 'Said at the start of a meal',
        arabic: 'بِسْمِ اللَّهِ',
        transliteration: 'Bismillah.',
        translation: 'In the name of Allah.',
        source: 'Al-Bukhari 5376',
        tip:
            'If you forget and remember mid-meal, say: "Bismillahi awwalahu wa akhirahu" — in the name of Allah at its beginning and its end.',
      ),
      Dua(
        id: 'meals-after',
        title: 'After eating',
        occasion: 'Said when finishing a meal',
        arabic:
            'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
        transliteration:
            'Alhamdu lillahil-ladhi at\'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah.',
        translation:
            'Praise be to Allah who fed me this and provided it for me, without any might or power on my part.',
        source: 'Abu Dawud 4023',
        tip: 'Gratitude turns an ordinary meal into worship.',
      ),
      Dua(
        id: 'meals-host',
        title: 'For the one who feeds you',
        occasion: 'Said for a host after eating with them',
        arabic:
            'اللَّهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِي وَاسْقِ مَنْ سَقَانِي',
        transliteration: 'Allahumma at\'im man at\'amani, wasqi man saqani.',
        translation:
            'O Allah, feed the one who fed me and give drink to the one who gave me drink.',
        source: 'Muslim 2055',
        tip:
            'A lovely one to say quietly at a friend\'s table — especially family who host you kindly.',
      ),
    ],
  ),
];

Dua? findDua(String id) {
  for (final category in kDuaCategories) {
    for (final dua in category.duas) {
      if (dua.id == id) return dua;
    }
  }
  return null;
}
