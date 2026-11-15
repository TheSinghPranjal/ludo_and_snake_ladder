import 'dart:math' as math;
import 'dart:ui';

/// WCAG relative luminance of [c].
double relativeLuminance(Color c) {
  double ch(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

/// WCAG contrast ratio between [a] and [b], from 1 to 21.
double contrastRatio(Color a, Color b) {
  final la = relativeLuminance(a);
  final lb = relativeLuminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Parses `#RRGGBB` or `#AARRGGBB`, or returns null.
Color? parseHexColor(Object? value) {
  if (value is! String || !value.startsWith('#')) return null;
  final hex = value.substring(1);
  if (hex.length != 6 && hex.length != 8) return null;
  final v = int.tryParse(hex, radix: 16);
  if (v == null) return null;
  return Color(hex.length == 6 ? 0xFF000000 | v : v);
}
