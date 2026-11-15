import 'package:dice_party/platform/ui/assets.dart';
import 'package:flutter/material.dart';

/// A round avatar.
class AvatarImage extends StatelessWidget {
  /// Creates an avatar of [index] with edge [size].
  const AvatarImage(this.index, {this.size = 40, super.key});

  /// Avatar index, 0..11.
  final int index;

  /// Edge length.
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    SharedAssets.avatar(index),
    width: size,
    height: size,
    semanticLabel: '${SharedAssets.avatarLabel(index)} avatar',
  );
}
