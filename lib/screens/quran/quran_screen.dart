import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../data/surahs.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/home_shell.dart';
import 'quran_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final palette = context.palette;

    final query = _query.trim().toLowerCase();
    final surahs = query.isEmpty
        ? kSurahs
        : kSurahs
            .where(
              (s) =>
                  s.name.toLowerCase().contains(query) ||
                  s.meaning.toLowerCase().contains(query) ||
                  s.number.toString() == query,
            )
            .toList();

    final reading = kSurahs[state.readingSurah - 1];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, kPillNavClearance),
        children: [
          Text('Quran', style: AppText.display(palette.ink, size: 28)),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search surahs…',
              prefixIcon: Icon(Icons.search_rounded, color: palette.inkMuted),
            ),
          ),
          const SizedBox(height: 16),
          _ContinueReadingCard(
            surah: reading,
            verse: state.readingVerse,
            onTap: () => QuranReaderScreen.open(context, reading),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.zero,
            radius: AppRadius.card,
            child: Column(
              children: [
                if (surahs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No surahs match "$_query".',
                      style: TextStyle(color: palette.inkMuted),
                    ),
                  ),
                for (var i = 0; i < surahs.length; i++) ...[
                  if (i > 0)
                    Divider(height: 1, indent: 18, color: palette.line),
                  _SurahRow(
                    surah: surahs[i],
                    readingNow: surahs[i].number == state.readingSurah,
                    onTap: () => QuranReaderScreen.open(context, surahs[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({
    required this.surah,
    required this.verse,
    required this.onTap,
  });

  final Surah surah;
  final int verse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.green,
      radius: AppRadius.cardLarge,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 18),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('Continue reading', color: AppColors.gold),
                const SizedBox(height: 7),
                Text(
                  '${surah.name} · verse $verse of ${surah.verseCount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: verse / surah.verseCount,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.gold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.4,
              ),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahRow extends StatelessWidget {
  const _SurahRow({
    required this.surah,
    required this.readingNow,
    required this.onTap,
  });

  final Surah surah;
  final bool readingNow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: readingNow ? palette.goldSoft : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              _NumberBadge(number: surah.number, highlighted: readingNow),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      readingNow
                          ? '${surah.meaning} · reading now'
                          : '${surah.meaning} · ${surah.verseCount} verses',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: readingNow
                            ? AppColors.goldDark
                            : palette.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                surah.arabicName,
                textDirection: TextDirection.rtl,
                style: AppText.arabic(palette.ink, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.highlighted});

  final int number;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: 38,
      height: 38,
      child: Center(
        child: Transform.rotate(
          angle: 0.785398, // 45° — the diamond frame from the mocks
          child: Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: highlighted ? AppColors.gold : Colors.transparent,
              border: highlighted ? null : Border.all(color: palette.line),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Transform.rotate(
                angle: -0.785398,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: highlighted ? Colors.white : palette.inkMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
