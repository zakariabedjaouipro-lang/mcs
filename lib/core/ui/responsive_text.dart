/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE TEXT | نصوص متجاوبة
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Text widgets that scale based on screen size

library;

import 'package:flutter/material.dart';

import 'package:mcs/core/ui/responsive_container.dart';

/// Responsive display heading (32-40px)
class DisplayText extends StatelessWidget {
  const DisplayText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.bold,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 28
        : context.isMediumScreen
            ? 32
            : 40;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive heading 1 (24-32px)
class Heading1 extends StatelessWidget {
  const Heading1(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.bold,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 20
        : context.isMediumScreen
            ? 24
            : 32;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive heading 2 (18-24px)
class Heading2 extends StatelessWidget {
  const Heading2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.bold,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 16
        : context.isMediumScreen
            ? 18
            : 24;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive heading 3 (16-20px)
class Heading3 extends StatelessWidget {
  const Heading3(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.w600,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 14
        : context.isMediumScreen
            ? 16
            : 20;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive body text large (16-18px)
class BodyLarge extends StatelessWidget {
  const BodyLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 14
        : context.isMediumScreen
            ? 16
            : 18;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
        height: 1.5,
      ),
    );
  }
}

/// Responsive body text medium (14-16px)
class BodyMedium extends StatelessWidget {
  const BodyMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 13
        : context.isMediumScreen
            ? 14
            : 16;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
        height: 1.5,
      ),
    );
  }
}

/// Responsive body text small (12-14px)
class BodySmall extends StatelessWidget {
  const BodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 11
        : context.isMediumScreen
            ? 12
            : 14;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Responsive caption (10-12px)
class Caption extends StatelessWidget {
  const Caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final baseSize = context.isSmallScreen
        ? 10
        : context.isMediumScreen
            ? 11
            : 12;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: baseSize * context.textScale,
        color: color ?? Colors.grey,
      ),
    );
  }
}
