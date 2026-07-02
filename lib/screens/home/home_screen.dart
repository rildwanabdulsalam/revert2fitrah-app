import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/home_shell.dart';

/// Home tab — profile and preferences, per mock 2g.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final palette = context.palette;
    final name = state.userName.isEmpty ? 'Friend' : state.userName;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, kPillNavClearance),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.green,
                child: Text(
                  name.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.userEmail,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: palette.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 10),
            child: Overline('Reminders'),
          ),
          _SettingsGroup(
            children: [
              _ToggleRow(
                title: 'Prayer time reminders',
                subtitle: 'Gentle notification at each prayer',
                value: state.prayerReminders,
                onChanged: state.setPrayerReminders,
              ),
              _ToggleRow(
                title: 'Dua of the Day',
                subtitle: 'One each morning',
                value: state.duaOfDayReminder,
                onChanged: state.setDuaOfDayReminder,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 10),
            child: Overline('Reading'),
          ),
          _SettingsGroup(
            children: [
              _ToggleRow(
                title: 'Transliteration',
                value: state.transliteration,
                onChanged: state.setTransliteration,
              ),
              _ToggleRow(
                title: 'Dark mode',
                value: state.darkMode,
                onChanged: state.setDarkMode,
              ),
              _LinkRow(
                title: 'Language',
                trailing: '${state.language} ›',
                onTap: () => _showLanguageSheet(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            children: [
              _LinkRow(
                title: 'Account & privacy',
                trailing: '›',
                onTap: () => showComingSoon(context, 'Account & privacy'),
              ),
              _LinkRow(
                title: 'Sign out',
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Center(
            child: Text(
              'Revert2Fitrah · Phase 1 · v0.1',
              style: TextStyle(fontSize: 12, color: palette.inkMuted),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final palette = context.palette;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
              child: Text(
                'Language',
                style: AppText.display(palette.ink, size: 20),
              ),
            ),
            ListTile(
              title: const Text('English'),
              trailing: const Icon(Icons.check_rounded, color: AppColors.green),
              onTap: () => Navigator.pop(sheetContext),
            ),
            ListTile(
              title: Text(
                'More languages coming soon',
                style: TextStyle(color: palette.inkMuted),
              ),
              enabled: false,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    final state = context.read<AppState>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        ),
        title: const Text('Sign out?'),
        content: const Text(
          'Your progress stays saved on this device for when you return.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              state.signOut();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      radius: AppRadius.card,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(height: 1, indent: 18, color: context.palette.line),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: palette.ink,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 12.5, color: palette.inkMuted),
                  ),
                ],
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.title, this.trailing, required this.onTap});

  final String title;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: palette.ink,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyle(fontSize: 14, color: palette.inkMuted),
              ),
          ],
        ),
      ),
    );
  }
}
