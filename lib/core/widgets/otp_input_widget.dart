/// OTP input widget — 6 individual digit fields with
/// auto-advance, paste support, and completion callback.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mcs/core/constants/app_constants.dart';
import 'package:mcs/core/constants/ui_constants.dart';

class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({
    required this.onCompleted,
    super.key,
    this.length = AppConstants.otpLength,
    this.fieldWidth = 48,
    this.fieldHeight = 56,
    this.autoFocus = true,
    this.onChanged,
  });

  final int length;
  final double fieldWidth;
  final double fieldHeight;
  final bool autoFocus;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    // Listen for paste on the first field.
    _controllers.first.addListener(_handlePaste);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode =>
      _controllers.map((c) => c.text).join();

  void _handlePaste() {
    final text = _controllers.first.text;
    if (text.length == widget.length && RegExp(r'^\d+$').hasMatch(text)) {
      for (var i = 0; i < widget.length; i++) {
        _controllers[i].text = text[i];
      }
      _focusNodes.last.requestFocus();
      _checkComplete();
    }
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste into a single field.
      _controllers[index].text = value[value.length - 1];
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    widget.onChanged?.call(_currentCode);
    _checkComplete();
  }

  void _onKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _checkComplete() {
    final code = _currentCode;
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: i == 0 || i == widget.length - 1
                  ? 0
                  : UiConstants.spacing4,
            ),
            child: SizedBox(
              width: widget.fieldWidth,
              height: widget.fieldHeight,
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (e) => _onKeyDown(e, i),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  autofocus: i == 0 && widget.autoFocus,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 2, // allows detecting paste
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        UiConstants.radiusMedium,
                      ),
                    ),
                  ),
                  onChanged: (v) => _onChanged(v, i),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
