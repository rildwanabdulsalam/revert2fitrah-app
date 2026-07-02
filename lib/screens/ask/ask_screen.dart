import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/ask_responses.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class _Message {
  const _Message.user(this.text)
      : isUser = true,
        sources = const [];
  const _Message.assistant(this.text, this.sources) : isUser = false;

  final String text;
  final bool isUser;
  final List<String> sources;
}

/// Ask tab (mock 2f): starter prompts, warm canned answers, and the pinned
/// "guidance, not a fatwa" framing on every response.
class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _messages = <_Message>[];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  var _thinking = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final question = text.trim();
    if (question.isEmpty || _thinking) return;
    _input.clear();
    setState(() {
      _messages.add(_Message.user(question));
      _thinking = true;
    });
    _scrollToEnd();

    // Stands in for the AI backend round-trip.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final answer = answerFor(
      question,
      name: context.read<AppState>().userName,
    );
    setState(() {
      _messages.add(_Message.assistant(answer.text, answer.sources));
      _thinking = false;
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ask', style: AppText.display(palette.ink, size: 28)),
                      const SizedBox(height: 4),
                      Text(
                        'No question is too small.',
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: palette.goldSoft,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: const Text(
                    'Guidance · not a fatwa',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              children: [
                if (_messages.isEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final prompt in kStarterPrompts)
                        _StarterChip(
                          label: prompt,
                          onTap: () => _send(prompt),
                        ),
                    ],
                  ),
                for (final message in _messages) ...[
                  message.isUser
                      ? _UserBubble(text: message.text)
                      : _AssistantBubble(
                          text: message.text,
                          sources: message.sources,
                        ),
                  const SizedBox(height: 12),
                ],
                if (_thinking)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: palette.card,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: SizedBox(
                        width: 34,
                        child: Text(
                          '···',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: palette.inkMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            // Sits above the floating pill nav.
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 86),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _send,
                    decoration:
                        const InputDecoration(hintText: 'Ask anything…'),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _send(_input.text),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarterChip extends StatelessWidget {
  const _StarterChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: palette.line),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: palette.ink,
          ),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({required this.text, required this.sources});

  final String text;
  final List<String> sources;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 330),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 14, height: 1.55, color: palette.ink),
            ),
            if (sources.isNotEmpty) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showSources(context),
                child: const Text(
                  'View sources ›',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.goldSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: GoldDiamond(size: 7),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is guidance, not a fatwa — for personal rulings, '
                      'please speak with a qualified scholar or imam.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: palette.ink,
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

  void _showSources(BuildContext context) {
    final palette = context.palette;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sources', style: AppText.display(palette.ink, size: 20)),
              const SizedBox(height: 14),
              for (final source in sources)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const GoldDiamond(size: 7),
                      const SizedBox(width: 10),
                      Text(
                        source,
                        style: TextStyle(fontSize: 14, color: palette.ink),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                'References are indicative in Phase 1 and will be linked to '
                'full texts once the vetted dataset is wired in.',
                style: TextStyle(fontSize: 12.5, color: palette.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
