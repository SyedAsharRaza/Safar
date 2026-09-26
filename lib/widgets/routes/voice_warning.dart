import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_misc.dart';
import '../../models/route_option.dart';
import '../../models/taxonomy.dart';
import '../common/badges.dart';
import '../common/inputs.dart';

/// Picks the warning script that matches what is actually on the route.
Map<String, String> voiceLineFor(RouteOption route) {
  if (!route.avoidsBlockage || route.blockageCount > 0) {
    return MockVoiceLines.blockedEnglish;
  }
  if (route.waterCount > 0) return MockVoiceLines.waterEnglish;
  if (route.lightingCount > 0) return MockVoiceLines.lightingEnglish;
  return MockVoiceLines.clearRoute;
}

/// The voice-warning player.
///
/// The blueprint calls for Flutter TTS here. This UI-only build shows the same
/// short scripts in English, Roman Urdu and Urdu with a live waveform and word
/// highlighting, so the multilingual warning is demonstrable with no audio
/// dependency. Wiring `flutter_tts` in later replaces only [_speak].
class VoiceWarningSheet extends StatefulWidget {
  const VoiceWarningSheet({
    super.key,
    required this.lines,
    required this.initialLanguage,
    this.title = 'Voice warning',
  });

  final Map<String, String> lines;
  final ReportLanguage initialLanguage;
  final String title;

  @override
  State<VoiceWarningSheet> createState() => _VoiceWarningSheetState();
}

class _VoiceWarningSheetState extends State<VoiceWarningSheet>
    with SingleTickerProviderStateMixin {
  late ReportLanguage _language = widget.initialLanguage == ReportLanguage.unknown
      ? ReportLanguage.english
      : widget.initialLanguage;

  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  Timer? _progress;
  int _spokenWords = 0;
  bool _playing = false;

  static const List<ReportLanguage> _choices = [
    ReportLanguage.english,
    ReportLanguage.romanUrdu,
    ReportLanguage.urdu,
  ];

  String get _text => widget.lines[_key(_language)] ?? widget.lines['en'] ?? '';

  List<String> get _words => _text.split(RegExp(r'\s+'));

  static String _key(ReportLanguage l) => switch (l) {
        ReportLanguage.urdu => 'ur',
        ReportLanguage.romanUrdu => 'roman',
        _ => 'en',
      };

  @override
  void initState() {
    super.initState();
    // Auto-play once when opened: a warning the traveller has to press for is
    // not much of a warning.
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  void dispose() {
    _progress?.cancel();
    _wave.dispose();
    super.dispose();
  }

  void _speak() {
    _progress?.cancel();
    setState(() {
      _playing = true;
      _spokenWords = 0;
    });
    _wave.repeat();

    // ~210 ms per word approximates a calm speaking pace.
    _progress = Timer.periodic(const Duration(milliseconds: 210), (timer) {
      if (!mounted) return timer.cancel();
      if (_spokenWords >= _words.length) {
        timer.cancel();
        _wave.stop();
        setState(() => _playing = false);
        return;
      }
      setState(() => _spokenWords++);
    });
  }

  void _stop() {
    _progress?.cancel();
    _wave.stop();
    setState(() {
      _playing = false;
      _spokenWords = _words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isUrdu = _language == ReportLanguage.urdu;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.xs, Gap.xl, Gap.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.title, style: t.headlineSmall),
              ),
              Pill(
                label: 'Text-to-speech preview',
                icon: Icons.graphic_eq_rounded,
                color: context.tokens.textSecondary,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: Gap.lg),

          SegmentedSelector<ReportLanguage>(
            values: _choices,
            selected: _language,
            labelOf: (l) => l.nativeLabel,
            onChanged: (l) {
              setState(() => _language = l);
              _speak();
            },
          ),
          const SizedBox(height: Gap.xl),

          // --- Waveform --------------------------------------------------------
          Container(
            height: 68,
            decoration: BoxDecoration(
              color: context.tokens.isDark
                  ? context.tokens.surfaceAlt
                  : context.scheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: Radii.allMd,
            ),
            child: AnimatedBuilder(
              animation: _wave,
              builder: (context, _) => CustomPaint(
                painter: _WavePainter(
                  phase: _wave.value,
                  active: _playing,
                  colour: context.scheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: Gap.xl),

          // --- Script with spoken words highlighted ----------------------------
          Directionality(
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            child: RichText(
              textAlign: isUrdu ? TextAlign.right : TextAlign.left,
              text: TextSpan(
                children: [
                  for (var i = 0; i < _words.length; i++)
                    TextSpan(
                      text: '${_words[i]} ',
                      style: (isUrdu ? t.headlineSmall : t.titleLarge)?.copyWith(
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: i < _spokenWords
                            ? context.tokens.textPrimary
                            : context.tokens.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Gap.xl),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _playing ? _stop : _speak,
                  icon: Icon(
                    _playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  ),
                  label: Text(_playing ? 'Stop' : 'Play warning'),
                ),
              ),
              const SizedBox(width: Gap.md),
              OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Done'),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          Text(
            'Warnings stay short so they are usable while travelling. Audio '
            'playback is simulated in this UI build.',
            style: t.labelMedium?.copyWith(color: context.tokens.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.phase,
    required this.active,
    required this.colour,
  });

  final double phase;
  final bool active;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 34;
    final gap = size.width / barCount;
    final centre = size.height / 2;

    for (var i = 0; i < barCount; i++) {
      // Two offset sine waves make the motion read as speech, not a metronome.
      final wobble = math.sin((i * 0.55) + phase * math.pi * 2) *
          math.sin((i * 0.17) + phase * math.pi * 4);
      final amplitude = active ? (0.25 + wobble.abs() * 0.75) : 0.12;
      final h = (size.height * 0.62) * amplitude;
      final x = gap * (i + 0.5);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centre),
            width: gap * 0.42,
            height: math.max(h, 3),
          ),
          const Radius.circular(3),
        ),
        Paint()
          ..color = colour.withValues(alpha: active ? 0.85 : 0.35),
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.phase != phase || old.active != active || old.colour != colour;
}
