import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// The app's name set in the display font: "Ludo" in the theme's red,
/// "& Snake Ladder" in green, scaled down to fit narrow screens.
class AppWordmark extends StatelessWidget {
  /// Creates the wordmark at [size] logical pixels.
  const AppWordmark({this.size = 40, super.key});

  /// Font size before any fit-to-width scaling.
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final style = TextStyle(
      fontFamily: displayFont,
      fontWeight: FontWeight.w700,
      fontSize: size,
      height: 1.1,
      color: c.text,
    );
    return Semantics(
      label: AppInfo.name,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            style: style,
            children: [
              TextSpan(
                text: 'Ludo',
                style: TextStyle(color: c.red),
              ),
              const TextSpan(text: ' & '),
              TextSpan(
                text: 'Snake Ladder',
                style: TextStyle(color: c.green),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }
}
