import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class _OnboardingPage {
  const _OnboardingPage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

const _pages = [
  _OnboardingPage(
    title: 'Revert2Fitrah',
    subtitle:
        'A gentle companion for the journey home — prayer, Quran, and answers, at your own pace.',
  ),
  _OnboardingPage(
    title: 'Learn without pressure',
    subtitle:
        'Solat step by step, duas with their sources, and the Quran with transliteration — no prior knowledge assumed.',
  ),
  _OnboardingPage(
    title: 'Ask anything',
    subtitle:
        'No question is too small. Warm, sourced guidance whenever you need it — never a fatwa, never judgement.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.green,
        body: Stack(
          children: [
            // Arch motif behind everything, rising from the bottom.
            Positioned.fill(
              top: 120,
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: ArchMotif(color: Colors.white.withValues(alpha: 0.14)),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, i) => _PageBody(page: _pages[i]),
                    ),
                  ),
                  _Dots(current: _page),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.greenDeep,
                        ),
                        onPressed: _next,
                        child: Text(
                          _page < _pages.length - 1
                              ? 'Begin your journey'
                              : 'Create your account',
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.85),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GoldDiamond(size: 12),
          const SizedBox(height: 26),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppText.display(Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _pages.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3.5),
            width: i == current ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == current
                  ? AppColors.gold
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
