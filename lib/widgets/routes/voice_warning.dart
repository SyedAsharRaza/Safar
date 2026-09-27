import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_misc.dart';
import '../../models/route_option.dart';
import '../../models/taxonomy.dart';
import '../../core/theme/app_colors.dart';
import '../common/badges.dart';
import '../common/surfaces.dart';
import '../common/inputs.dart';
import '../../l10n/app_localizations.dart';

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
/// Speaks the warning aloud through the device's text-to-speech engine, with a
/// waveform and word highlighting so the warning is followable with the sound
/// off too.
///
/// Engine coverage varies by handset: many Android devices have no Urdu or
/// Punjabi voice installed. Rather than failing silently, the player falls back
/// to Hindi (acoustically close for Urdu) and then to the device default, and
/// tells the user when it is reading a script in a substitute voice.
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

  final FlutterTts _tts = FlutterTts();

  Timer? _progress;
  int _spokenWords = 0;
  bool _playing = false;

  /// Set when the requested language has no installed voice.
  String? _voiceNotice;
  bool _ttsReady = false;

  static const List<ReportLanguage> _choices = ReportLanguage.selectable;

  String get _text => widget.lines[_key(_language)] ?? widget.lines['en'] ?? '';

  List<String> get _words => _text.split(RegExp(r'\s+'));

  static String _key(ReportLanguage l) => switch (l) {
        ReportLanguage.urdu => 'ur',
        ReportLanguage.punjabi => 'pa',
        ReportLanguage.romanUrdu => 'roman',
        _ => 'en',
      };

  @override
  void initState() {
    super.initState();
    _initTts().then((_) {
      // Auto-play once when opened: a warning the traveller has to press for is
      // not much of a warning.
      if (mounted) _speak();
    });
  }

  /// BCP-47 tags the TTS engine understands, best first.
  static List<String> _ttsCandidates(ReportLanguage l) => switch (l) {
        ReportLanguage.urdu => ['ur-PK', 'ur', 'hi-IN'],
        ReportLanguage.punjabi => ['pa-IN', 'pa', 'ur-PK', 'hi-IN'],
        ReportLanguage.romanUrdu => ['hi-IN', 'en-IN', 'en-US'],
        _ => ['en-IN', 'en-US', 'en-GB'],
      };

  Future<void> _initTts() async {
    try {
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _playing = false);
      });
      _ttsReady = true;
    } catch (_) {
      _ttsReady = false;
    }
  }

  /// Picks the best available voice, noting when it is a substitute.
  Future<String?> _applyLanguage() async {
    final candidates = _ttsCandidates(_language);
    for (final tag in candidates) {
      try {
        final available = await _tts.isLanguageAvailable(tag);
        if (available == true) {
          await _tts.setLanguage(tag);
          final exact = tag.startsWith(candidates.first.split('-').first);
          return exact ? null : tag;
        }
      } catch (_) {
        // Try the next candidate.
      }
    }
    return 'unavailable';
  }

  @override
  void dispose() {
    _progress?.cancel();
    _tts.stop();
    _wave.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    _progress?.cancel();
    await _tts.stop();

    String? notice;
    if (_ttsReady) {
      final substitute = await _applyLanguage();
      if (substitute == 'unavailable') {
        notice = 'No installed voice for ${_language.label}. '
            'Showing the text only.';
      } else if (substitute != null) {
        notice = 'Read in the closest available voice — your device has no '
            '${_language.label} voice installed.';
      }
    } else {
      notice = 'Text-to-speech is unavailable on this device.';
    }

    if (!mounted) return;
    setState(() {
      _playing = true;
      _spokenWords = 0;
      _voiceNotice = notice;
    });
    _wave.repeat();

    if (_ttsReady && notice != 'No installed voice for ${_language.label}. '
        'Showing the text only.') {
      _tts.speak(_text);
    }

    // Word highlighting runs alongside the audio so the warning is followable
    // with the sound off. ~210 ms per word matches a calm speaking pace.
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

  Future<void> _stop() async {
    _progress?.cancel();
    await _tts.stop();
    _wave.stop();
    if (!mounted) return;
    setState(() {
      _playing = false;
      _spokenWords = _words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    // Urdu and Punjabi both render right-to-left.
    final isRtl = _language.isRtl;

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
                label: L.of(context).textSpeechPreview,
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
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: RichText(
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              text: TextSpan(
                children: [
                  for (var i = 0; i < _words.length; i++)
                    TextSpan(
                      text: '${_words[i]} ',
                      style: (isRtl ? t.headlineSmall : t.titleLarge)?.copyWith(
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
                child: Text(L.of(context).done),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          if (_voiceNotice != null) ...[
            InfoPanel(
              text: _voiceNotice!,
              icon: Icons.record_voice_over_outlined,
              tone: AppColors.awarenessModerate,
              dense: true,
            ),
            const SizedBox(height: Gap.sm),
          ],
          Text(
            L.of(context).warningsStayShortSoThey,
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
