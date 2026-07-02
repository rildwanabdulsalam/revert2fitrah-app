import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/duas.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../shell/home_shell.dart';
import 'dua_detail_screen.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  var _categoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final todaysDuaId = context.watch<AppState>().todaysDuaId;
    final category = kDuaCategories[_categoryIndex];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, kPillNavClearance),
        children: [
          Text('Duas', style: AppText.display(palette.ink, size: 28)),
          const SizedBox(height: 6),
          Text(
            'Words for every moment — each with its source.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: palette.inkMuted,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (var i = 0; i < kDuaCategories.length; i++) ...[
                  _CategoryChip(
                    label: kDuaCategories[i].name,
                    active: i == _categoryIndex,
                    onTap: () => setState(() => _categoryIndex = i),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < category.duas.length; i++) ...[
            _DuaCard(
              dua: category.duas[i],
              isTodays: category.duas[i].id == todaysDuaId,
              onTap: () => DuaDetailScreen.open(
                context,
                category: category,
                index: i,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppColors.green : palette.card,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: active ? AppColors.green : palette.line),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? Colors.white : palette.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  const _DuaCard({
    required this.dua,
    required this.isTodays,
    required this.onTap,
  });

  final Dua dua;
  final bool isTodays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      radius: AppRadius.card,
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
      border: isTodays
          ? Border.all(color: AppColors.goldBorder, width: 1.6)
          : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: palette.ink,
                      ),
                    ),
                    if (isTodays) ...[
                      const SizedBox(height: 4),
                      const Overline("Today's dua", color: AppColors.goldDark),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  const GoldDiamond(size: 7),
                  const SizedBox(width: 6),
                  Text(
                    dua.source,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: palette.inkMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              dua.arabic,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
              style: AppText.arabic(palette.ink, size: 20),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${dua.translation.split('.').first}…',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: palette.inkMuted),
          ),
        ],
      ),
    );
  }
}
