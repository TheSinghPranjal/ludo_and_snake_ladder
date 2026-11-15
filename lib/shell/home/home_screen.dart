import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/audio/music_scope.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/shell/home/home_palette.dart';
import 'package:dice_party/shell/hub/hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Width / height of the Home artwork.
const double _artAspect = 941 / 1671;

/// Fraction of the artwork's height that must stay above the buttons: the
/// title ribbon ends at ~72% and the flowers at ~85%.
const double _artVisible = 0.86;

/// The Home screen: the illustrated title art, the player's profile and
/// Settings on top, and Play, Stats and How to Play below.
class HomeScreen extends ConsumerWidget {
  /// Creates Home.
  const HomeScreen({super.key});

  /// Height of the Play button.
  static const double playHeight = 68;

  /// Height of the Stats and How to Play buttons.
  static const double buttonHeight = 52;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).value;
    final profile = ref.watch(profileControllerProvider);
    final audio = ref.watch(appServicesProvider).audio;
    final pad = MediaQuery.paddingOf(context);
    return MusicScope(
      audio: audio,
      track: MusicTrack.hub,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: HomePalette.cream,
          body: LayoutBuilder(
            builder: (context, box) {
              final bottomPad = math.max(pad.bottom, Space.l) + Space.s;
              final panel =
                  bottomPad + buttonHeight + Space.l + playHeight + Space.l;
              return Stack(
                children: [
                  _Art(
                    width: box.maxWidth,
                    maxHeight: (box.maxHeight - panel) / _artVisible,
                  ),
                  Positioned(
                    top: pad.top + Space.m,
                    left: Space.l,
                    right: Space.l,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _ProfileChip(
                              name: profile.name,
                              avatar: profile.avatar,
                            ),
                          ),
                        ),
                        const SizedBox(width: Space.m),
                        _SettingsButton(
                          onTap: () => context.push(AppRoutes.settings),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: Space.l,
                    right: Space.l,
                    bottom: bottomPad,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: Space.maxContent,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PlayButton(
                              onTap: () => context.push(AppRoutes.hub),
                            ),
                            const SizedBox(height: Space.l),
                            Row(
                              children: [
                                Expanded(
                                  child: _CreamButton(
                                    icon: 'stats',
                                    label: 'Stats',
                                    onTap: () => context.push(AppRoutes.stats),
                                  ),
                                ),
                                const SizedBox(width: Space.m),
                                Expanded(
                                  child: _CreamButton(
                                    icon: 'info',
                                    label: 'How to Play',
                                    onTap: catalog == null
                                        ? null
                                        : () => unawaited(
                                            showHowToPlayPicker(
                                              context,
                                              catalog,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The title artwork, full width at the top, fading into cream at the
/// bottom. On short screens it shrinks so the title stays above the
/// buttons, over a blurred copy that fills the sides.
class _Art extends StatelessWidget {
  const _Art({required this.width, required this.maxHeight});

  final double width;
  final double maxHeight;

  static const _image = AssetImage(SharedAssets.homeBackground);

  @override
  Widget build(BuildContext context) {
    final height = math.min(width / _artAspect, maxHeight);
    final artWidth = height * _artAspect;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Semantics(
        header: true,
        label: '${AppInfo.name}. Roll the dice and race your friends',
        excludeSemantics: true,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HomePalette.white, HomePalette.white, HomePalette.clear],
            stops: [0, 0.8, 0.95],
          ).createShader(rect),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (artWidth < width - 1)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: const Image(
                    image: _image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: artWidth,
                  height: height,
                  child: artWidth < width - 1
                      ? ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (rect) => const LinearGradient(
                            colors: [
                              HomePalette.clear,
                              HomePalette.white,
                              HomePalette.white,
                              HomePalette.clear,
                            ],
                            stops: [0, 0.08, 0.92, 1],
                          ).createShader(rect),
                          child: const Image(image: _image, fit: BoxFit.fill),
                        )
                      : const Image(image: _image, fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Soft drop shadow shared by the cream controls.
const List<BoxShadow> _softShadow = [
  BoxShadow(color: HomePalette.shadow, blurRadius: 12, offset: Offset(0, 4)),
];

TextStyle _label(double size) => TextStyle(
  fontFamily: displayFont,
  fontWeight: FontWeight.w600,
  fontSize: size,
  height: 1.1,
  color: HomePalette.ink,
);

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.name, required this.avatar});

  final String name;
  final int avatar;

  static const double _avatar = 48;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Profile, $name',
    excludeSemantics: true,
    child: _Pressable(
      onTap: () => context.push(AppRoutes.profile),
      child: SizedBox(
        height: _avatar + 4,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: _avatar / 2),
              padding: const EdgeInsets.only(
                left: _avatar / 2 + Space.m,
                right: Space.xl,
              ),
              decoration: BoxDecoration(
                color: HomePalette.chip.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _softShadow,
              ),
              child: Align(
                widthFactor: 1,
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _label(20),
                ),
              ),
            ),
            Container(
              width: _avatar + 4,
              height: _avatar + 4,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [HomePalette.ringLight, HomePalette.ringDark],
                ),
                boxShadow: _softShadow,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: HomePalette.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(child: AvatarImage(avatar, size: _avatar)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'Settings',
    child: Semantics(
      button: true,
      label: 'Settings',
      excludeSemantics: true,
      child: _Pressable(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: HomePalette.chip.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: HomePalette.white, width: 1.5),
            boxShadow: _softShadow,
          ),
          alignment: Alignment.center,
          child: const AppIcon('settings', size: 28, color: HomePalette.ink),
        ),
      ),
    ),
  );
}

/// The big glossy blue Play button.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Play',
    excludeSemantics: true,
    child: _Pressable(
      onTap: onTap,
      child: Container(
        height: HomeScreen.playHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HomeScreen.playHeight / 2),
          border: Border.all(color: HomePalette.white, width: 3),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HomePalette.playTop,
              HomePalette.playMid,
              HomePalette.playBottom,
            ],
            stops: [0, 0.55, 1],
          ),
          boxShadow: const [
            BoxShadow(
              color: HomePalette.playGlow,
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: HomePalette.rimGlow,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glossy highlight across the top.
            Positioned(
              top: 2,
              left: 28,
              right: 28,
              height: HomeScreen.playHeight * 0.34,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(HomeScreen.playHeight),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HomePalette.white.withValues(alpha: 0.22),
                      HomePalette.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomPaint(size: Size(28, 32), painter: _PlayTriangle()),
                const SizedBox(width: Space.xs),
                const SizedBox(width: Space.s),
                Text(
                  'Play',
                  style: _label(36).copyWith(
                    fontWeight: FontWeight.w700,
                    color: HomePalette.white,
                    shadows: const [
                      Shadow(
                        color: HomePalette.playShade,
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// A white play triangle with rounded corners and a soft shadow.
class _PlayTriangle extends CustomPainter {
  const _PlayTriangle();

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 4.0;
    final path = Path()
      ..moveTo(inset, inset)
      ..lineTo(size.width - inset, size.height / 2)
      ..lineTo(inset, size.height - inset)
      ..close();
    final rounded = Paint()
      ..strokeWidth = inset * 2
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawPath(
        path.shift(const Offset(0, 2)),
        Paint()
          ..color = HomePalette.playShadeSoft
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      )
      ..drawPath(
        path,
        rounded
          ..color = HomePalette.white
          ..style = PaintingStyle.stroke,
      )
      ..drawPath(path, Paint()..color = HomePalette.white);
  }

  @override
  bool shouldRepaint(_PlayTriangle oldDelegate) => false;
}

/// A cream pill button with an icon and label.
class _CreamButton extends StatelessWidget {
  const _CreamButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onTap != null,
    label: label,
    excludeSemantics: true,
    child: _Pressable(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.6 : 1,
        child: Container(
          height: HomeScreen.buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: Space.m),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: HomePalette.white, width: 2.5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [HomePalette.buttonTop, HomePalette.buttonBottom],
            ),
            boxShadow: _softShadow,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(icon, color: HomePalette.ink),
                const SizedBox(width: Space.s),
                Text(label, style: _label(21)),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Shrinks its child slightly while pressed.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  void _set({required bool down}) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _set(down: true) : null,
      onTapUp: enabled ? (_) => _set(down: false) : null,
      onTapCancel: enabled ? () => _set(down: false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 90),
        child: widget.child,
      ),
    );
  }
}
