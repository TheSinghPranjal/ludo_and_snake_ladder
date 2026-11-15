import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:flutter/material.dart';

/// One of the app's monochrome icons, tinted with the theme's text colour
/// unless [color] is given.
class AppIcon extends StatelessWidget {
  /// Creates an icon.
  const AppIcon(this.name, {this.size = 24, this.color, super.key});

  /// Icon name, e.g. `settings`.
  final String name;

  /// Edge length.
  final double size;

  /// Tint.
  final Color? color;

  @override
  Widget build(BuildContext context) => Image.asset(
    SharedAssets.icon(name),
    width: size,
    height: size,
    color: color ?? IconTheme.of(context).color ?? AppColors.of(context).text,
    excludeFromSemantics: true,
  );
}
