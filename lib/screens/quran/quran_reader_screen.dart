import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../data/verses.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Verse-by-verse reader with the floating audio bar (mock 2d).
///
/// "Playback" is simulated: a timer sweeps the progress bar and advances to
/// the next verse, standing in for the real recitation audio that arrives
/// with the licensed dataset.
class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({super.key, required this.surah});

  final Surah surah;

  static void open(BuildContext context, Surah surah) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => QuranReaderScreen(surah: surah)),
    );
  }

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  static const _textScales = [0.9, 1.0, 1.15];
  static const _speeds = [1.0, 1.25, 1.5, 0.75];
  static const _verseSeconds = 24.0;

  late final List<Verse> _verses = kSampleVerses[widget.surah.number] ?? [];
  late int _currentVerse; // 1-based
  var _playing = false;
  var _progress = 0.0;
  var _scaleIndex = 1;
  var _speedIndex = 0;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _currentVerse = state.readingSurah == widget.surah.number
        ? state.readingVerse.clamp(1, widget.surah.verseCount)
        : 1;
    // Opening a surah makes it the "continue reading" surah.
    state.setReadingPosition(widget.surah.number, _currentVerse);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_verses.isEmpty) {
      showComingSoon(context, 'Recitation audio for this surah');
      return;
    }
    setState(() => _playing = !_playing);
    _ticker?.cancel();
    if (_playing) {
      _ticker = Timer.periodic(const Duration(milliseconds: 120), (_) {
        setState(() {
          _progress += 0.12 * _speeds[_speedIndex] / _verseSeconds;
          if (_progress >= 1) {
            _progress = 0;
            if (_currentVerse < _verses.length) {
              _setVerse(_currentVerse + 1);
            } else {
              _playing = false;
              _ticker?.cancel();
            }
          }
        });
      });
    }
  }

  void _setVerse(int verse) {
    _currentVerse = verse;
    context
        .read<AppState>()
        .setReadingPosition(widget.surah.number, verse);
  }

  void _cycleSpeed() {
    setState(() => _speedIndex = (_speedIndex + 1) % _speeds.length);
  }

  void _cycleTextSize() {
    setState(() => _scaleIndex = (_scaleIndex + 1) % _textScales.length);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final showTransliteration = context.select<AppState, bool>(
      (s) => s.transliteration,
    );
    final scale = _textScales[_scaleIndex];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        leadingWidth: 32,
        centerTitle: true,
        title: Column(
          children: [
            Text(widget.surah.name),
            Text(
              '${widget.surah.meaning} · ${widget.surah.number} · '
              '${widget.surah.verseCount} verses',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: palette.inkMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: _cycleTextSize, child: const Text('Aa')),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          if (_verses.isEmpty)
            _PendingTextNotice(surah: widget.surah)
          else
            ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
              itemCount: _verses.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final verse = _verses[i];
                final isCurrent = verse.number == _currentVerse;
                return _VerseCard(
                  verse: verse,
                  isCurrent: isCurrent,
                  playing: _playing && isCurrent,
                  showTransliteration: showTransliteration,
                  scale: scale,
                  onTap: () => setState(() {
                    _progress = 0;
                    _setVerse(verse.number);
                  }),
                );
              },
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _AudioBar(
              label: '${widget.surah.name} · verse $_currentVerse',
              playing: _playing,
              progress: _progress,
              speed: _speeds[_speedIndex],
              onPlay: _togglePlay,
              onSpeed: _cycleSpeed,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  const _VerseCard({
    required this.verse,
    required this.isCurrent,
    required this.playing,
    required this.showTransliteration,
    required this.scale,
    required this.onTap,
  });

  final Verse verse;
  final bool isCurrent;
  final bool playing;
  final bool showTransliteration;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      radius: AppRadius.cardLarge,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      border: isCurrent
          ? Border.all(color: AppColors.goldBorder, width: 1.4)
          : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.goldSoft : palette.greenSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${verse.number}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isCurrent ? AppColors.goldDark : AppColors.green,
                  ),
                ),
              ),
              const Spacer(),
              if (playing) ...[
                Text(
                  'Playing',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              verse.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppText.arabic(palette.ink, size: 25 * scale),
            ),
          ),
          if (showTransliteration) ...[
            const SizedBox(height: 10),
            Text(
              verse.transliteration,
              style: TextStyle(
                fontSize: 13 * scale,
                fontStyle: FontStyle.italic,
                height: 1.55,
                color: palette.inkMuted,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            verse.translation,
            style: TextStyle(
              fontSize: 14 * scale,
              height: 1.55,
              color: palette.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTextNotice extends StatelessWidget {
  const _PendingTextNotice({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoldDiamond(size: 12),
            const SizedBox(height: 18),
            Text(
              surah.arabicName,
              textDirection: TextDirection.rtl,
              style: AppText.arabic(palette.ink, size: 34),
            ),
            const SizedBox(height: 10),
            Text(
              '${surah.name} — text coming soon',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: palette.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The full, scholar-reviewed Quran text and audio arrive with '
              'the licensed dataset. Al-Fatihah, Al-Mulk, and Al-Ikhlas are '
              'available now as a preview.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.55,
                color: palette.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioBar extends StatelessWidget {
  const _AudioBar({
    required this.label,
    required this.playing,
    required this.progress,
    required this.speed,
    required this.onPlay,
    required this.onSpeed,
  });

  final String label;
  final bool playing;
  final double progress;
  final double speed;
  final VoidCallback onPlay;
  final VoidCallback onSpeed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.ink,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3.5,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onSpeed,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Text(
                  '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 1 : 2)}×',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
