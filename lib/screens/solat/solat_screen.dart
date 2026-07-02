import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/lessons.dart';
import '../../data/models.dart';
import '../../data/prayers.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/home_shell.dart';
import 'lesson_screen.dart';

/// Placeholder prayer times until a real prayer-time engine (location +
/// calculation method) is wired in.
const _prayerTimeHints = {
  'fajr': 'dawn',
  'dhuhr': 'next at 1:08 PM',
  'asr': 'afternoon',
  'maghrib': 'sunset',
  'isha': 'night',
};

class SolatScreen extends StatelessWidget {
  const SolatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final palette = context.palette;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, kPillNavClearance),
        children: [
          Text('Solat Guide', style: AppText.display(palette.ink, size: 28)),
          const SizedBox(height: 6),
          Text(
            'Step by step, at your own pace — no prior knowledge assumed.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: palette.inkMuted,
            ),
          ),
          const SizedBox(height: 20),
          _WuduCard(
            onTap: () => LessonScreen.open(context, kWuduLesson),
          ),
          const SizedBox(height: 14),
          for (final prayer in kPrayers) ...[
            _PrayerCard(prayer: prayer, state: state),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _WuduCard extends StatelessWidget {
  const _WuduCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.green,
      radius: AppRadius.cardLarge,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Overline('Start here', color: AppColors.gold),
          const SizedBox(height: 8),
          const Text(
            'Wudu — washing before prayer',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '8 short steps · about 4 minutes to learn',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({required this.prayer, required this.state});

  final Prayer prayer;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final learned = state.lessonLearned(prayer.id);
    final step = state.lessonStep(prayer.id);
    final inProgress = !learned && step > 0;

    final subtitleParts = <String>[
      "${prayer.rakah} rak'ah",
      _prayerTimeHints[prayer.id] ?? prayer.timeOfDay,
      if (learned) 'learned ✓' else if (inProgress) 'continue learning',
    ];

    return AppCard(
      radius: AppRadius.card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: inProgress
          ? Border.all(color: AppColors.goldBorder, width: 1.6)
          : null,
      onTap: () => LessonScreen.open(context, salahLesson(prayer)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: learned
                  ? AppColors.green
                  : inProgress
                      ? AppColors.goldSoft
                      : palette.greenSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mosque_outlined,
              size: 20,
              color: learned
                  ? Colors.white
                  : inProgress
                      ? AppColors.goldDark
                      : AppColors.green,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.name,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: palette.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitleParts.join(' · '),
                  style: TextStyle(fontSize: 12.5, color: palette.inkMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.inkMuted),
        ],
      ),
    );
  }
}
