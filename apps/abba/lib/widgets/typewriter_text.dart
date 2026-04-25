import 'dart:async';

import 'package:flutter/material.dart';

/// Typewriter effect — reveals [text] one character at a time at
/// [charDelay] interval. No animation if text is empty.
///
/// Design note: fake streaming that mimics ChatGPT-style incremental
/// reveal for Dashboard's prayer_summary. Uses data the client already
/// has from Polling — costs 0 extra API tokens.
///
/// Seniors-friendly default: 40ms/char (≈25 chars/second). Tunable via
/// [charDelay].
class TypewriterText extends StatefulWidget {
  final String text;
  final Duration charDelay;
  final TextStyle? style;
  final TextAlign? textAlign;
  final VoidCallback? onComplete;

  /// When false (default), the full text is shown instantly with no
  /// animation. Useful for when the user revisits a prayer (no need
  /// to re-type the same summary they've already read).
  final bool animate;

  const TypewriterText({
    super.key,
    required this.text,
    this.charDelay = const Duration(milliseconds: 40),
    this.style,
    this.textAlign,
    this.onComplete,
    this.animate = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late String _displayed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.animate && widget.text.isNotEmpty) {
      _displayed = '';
      _startTyping();
    } else {
      _displayed = widget.text;
    }
  }

  void _startTyping() {
    var i = 0;
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (i >= widget.text.length) {
        timer.cancel();
        widget.onComplete?.call();
        return;
      }
      setState(() {
        i++;
        _displayed = widget.text.substring(0, i);
      });
    });
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Text changed mid-animation — restart from scratch if still animating.
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      if (widget.animate && widget.text.isNotEmpty) {
        _displayed = '';
        _startTyping();
      } else {
        _displayed = widget.text;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayed, style: widget.style, textAlign: widget.textAlign);
  }
}
