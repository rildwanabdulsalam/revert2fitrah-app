import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Step-by-step lesson player (mock 3a): segmented progress, illustration
/// placeholder, posture overline, and the recitation card.
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  static void open(BuildContext context, Lesson lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
    );
  }

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late int _step; // 1-based

  @override
  void initState() {
    super.initState();
    final saved = context.read<AppState>().lessonStep(widget.lesson.id);
    _step = saved.clamp(1, widget.lesson.steps.length);
  }

  void _goTo(int step) {
    setState(() => _step = step);
    context.read<AppState>().setLessonStep(widget.lesson.id, step);
  }

  void _next() {
    if (_step < widget.lesson.steps.length) {
      _goTo(_step + 1);
    } else {
      final state = context.read<AppState>();
      state.markLessonLearned(widget.lesson.id);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.lesson.title} learned — beautifully done. '
            'Repetition will make it feel like home.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final steps = widget.lesson.steps;
    final step = steps[_step - 1];
    final isLast = _step == steps.length;
    final showTransliteration = context.select<AppState, bool>(
      (s) => s.transliteration,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        leadingWidth: 32,
        centerTitle: false,
        title: Text(widget.lesson.title),
        actions: [
          TextButton(
            onPressed: () => showComingSoon(context, 'Step audio'),
            child: const Text('Audio'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step $_step of ${steps.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SegmentedProgress(current: _step, total: steps.length),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IllustrationPlaceholder(label: step.illustrationLabel),
                    const SizedBox(height: 22),
                    Overline(step.posture, color: AppColors.goldDark),
                    const SizedBox(height: 8),
                    Text(
                      step.title,
                      style: AppText.display(palette.ink, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      step.body,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.6,
                        color: palette.inkMuted,
                      ),
                    ),
                    if (step.recitation != null) ...[
                      const SizedBox(height: 18),
                      _RecitationCard(
                        recitation: step.recitation!,
                        showTransliteration: showTransliteration,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _step > 1
                        ? () => _goTo(_step - 1)
                        : () => Navigator.of(context).pop(),
                    child: const Text('‹ Back'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(
                        isLast
                            ? 'Finish — well done'
                            : 'Next: ${_nextLabel(steps[_step].title)} ›',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nextLabel(String title) =>
      title.length > 24 ? '${title.substring(0, 22)}…' : title;
}

class _SegmentedProgress extends StatelessWidget {
  const _SegmentedProgress({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        for (var i = 1; i <= total; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < current
                    ? AppColors.green
                    : i == current
                        ? AppColors.gold
                        : palette.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (i < total) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

class _RecitationCard extends StatelessWidget {
  const _RecitationCard({
    required this.recitation,
    required this.showTransliteration,
  });

  final Recitation recitation;
  final bool showTransliteration;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      radius: AppRadius.cardLarge,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              recitation.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppText.arabic(palette.ink, size: 26),
            ),
          ),
          if (showTransliteration) ...[
            const SizedBox(height: 8),
            Text(
              recitation.transliteration,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.55,
                color: palette.inkMuted,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            recitation.translation,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: palette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
