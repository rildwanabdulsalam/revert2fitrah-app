import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The small rotated-square "sacred marker" used throughout the mocks.
class GoldDiamond extends StatelessWidget {
  const GoldDiamond({super.key, this.size = 10, this.color = AppColors.gold});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
      ),
    );
  }
}

/// White rounded card, r20–26 per the design system.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final BoxBorder? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? context.palette.card,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      ),
    );
  }
}

/// SMALL-CAPS section label ("REMINDERS", "SOURCE · AT-TIRMIDHI 3391").
class Overline extends StatelessWidget {
  const Overline(this.text, {super.key, this.color, this.size = 11});

  final String text;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppText.overline(color ?? context.palette.inkMuted, size: size),
    );
  }
}

/// Concentric pointed-arch outlines used on the onboarding hero.
class ArchMotif extends StatelessWidget {
  const ArchMotif({super.key, this.color = Colors.white24});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ArchPainter(color));
  }
}

class _ArchPainter extends CustomPainter {
  _ArchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = color;

    // Nested pointed arches, anchored to the bottom of the canvas.
    for (var i = 0; i < 3; i++) {
      final inset = i * 34.0;
      final w = size.width - inset * 2;
      final left = inset;
      final right = inset + w;
      final bottom = size.height;
      final apex = inset + w * 0.16;

      final path = Path()
        ..moveTo(left, bottom)
        ..lineTo(left, apex + w * 0.32)
        ..quadraticBezierTo(left, apex, size.width / 2, apex - w * 0.06)
        ..quadraticBezierTo(right, apex, right, apex + w * 0.32)
        ..lineTo(right, bottom);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_ArchPainter oldDelegate) => oldDelegate.color != color;
}

/// Diagonal-hatch placeholder block for lesson illustrations.
class IllustrationPlaceholder extends StatelessWidget {
  const IllustrationPlaceholder({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.cardLarge),
      child: CustomPaint(
        painter: _HatchPainter(palette.line.withValues(alpha: 0.55)),
        child: Container(
          height: 230,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.cardLarge),
            border: Border.all(color: palette.line),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.line),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 0.3,
                color: palette.inkMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  _HatchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 10;
    const gap = 26.0;
    for (var x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) => oldDelegate.color != color;
}

void showComingSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what is coming soon, insha\'Allah.')));
}
