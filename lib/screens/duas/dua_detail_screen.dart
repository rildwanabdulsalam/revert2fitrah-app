import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Full dua view (mock 3c): Arabic, transliteration, translation, source,
/// listen + remind actions, and previous/next within the category.
class DuaDetailScreen extends StatefulWidget {
  const DuaDetailScreen({
    super.key,
    required this.category,
    required this.index,
  });

  final DuaCategory category;
  final int index;

  static void open(
    BuildContext context, {
    required DuaCategory category,
    required int index,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DuaDetailScreen(category: category, index: index),
      ),
    );
  }

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late var _index = widget.index;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final state = context.watch<AppState>();
    final duas = widget.category.duas;
    final dua = duas[_index];
    final reminderSet = state.duaReminderSet(dua.id);
    final showTransliteration = state.transliteration;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        leadingWidth: 32,
        centerTitle: false,
        title: Text(widget.category.name),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: palette.greenSoft,
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: Text(
              '${widget.category.name} · ${_index + 1} of ${duas.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: GoldDiamond(size: 10)),
                    const SizedBox(height: 14),
                    Text(
                      dua.title,
                      textAlign: TextAlign.center,
                      style: AppText.display(palette.ink, size: 23),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dua.occasion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: palette.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppCard(
                      radius: AppRadius.cardLarge,
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
                      child: Column(
                        children: [
                          Text(
                            dua.arabic,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: AppText.arabic(palette.ink, size: 27),
                          ),
                          if (showTransliteration) ...[
                            const SizedBox(height: 14),
                            Text(
                              dua.transliteration,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                                color: palette.inkMuted,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            dua.translation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.6,
                              color: palette.ink,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Divider(color: palette.line),
                          const SizedBox(height: 10),
                          Overline('Source · ${dua.source}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.play_arrow_rounded,
                            iconBackground: AppColors.green,
                            iconColor: Colors.white,
                            label: 'Listen',
                            onTap: () => showComingSoon(context, 'Dua audio'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: reminderSet
                                ? Icons.notifications_active
                                : Icons.notifications_none_rounded,
                            iconBackground: AppColors.goldSoft,
                            iconColor: AppColors.goldDark,
                            label: reminderSet ? 'Reminder on' : 'Remind me',
                            onTap: () {
                              state.toggleDuaReminder(dua.id);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      reminderSet
                                          ? 'Reminder removed.'
                                          : 'We\'ll gently remind you of "${dua.title}".',
                                    ),
                                  ),
                                );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (dua.tip != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.greenSoft,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: GoldDiamond(size: 8),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                dua.tip!,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.55,
                                  color: palette.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _index > 0
                        ? () => setState(() => _index--)
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: palette.inkMuted,
                    ),
                    child: const Text('‹ Previous'),
                  ),
                  TextButton(
                    onPressed: _index < duas.length - 1
                        ? () => setState(() => _index++)
                        : null,
                    child: const Text('Next dua ›'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      radius: AppRadius.card,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
