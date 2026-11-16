import 'dart:math' as math;

import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';

/// Label text on the cream meadow controls.
const meadowLabelStyle = TextStyle(
  fontFamily: displayFont,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HomePalette.meadowInk,
);

/// The cream panel that holds a meadow screen's controls.
class MeadowPanel extends StatelessWidget {
  /// Creates the panel.
  const MeadowPanel({required this.child, super.key});

  /// Panel content.
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      Space.l,
      Space.m,
      Space.l,
      Space.l + Space.xs,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [HomePalette.panelTop, HomePalette.panelBottom],
      ),
      border: Border.all(color: HomePalette.white, width: 2.5),
      boxShadow: const [
        BoxShadow(
          color: HomePalette.shadow,
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

/// One of the colourful illustrated icons, by name (see
/// [SharedAssets.meadowIcon]).
class MeadowIcon extends StatelessWidget {
  /// Creates the icon.
  const MeadowIcon(this.name, {this.size = 32, super.key});

  /// Icon name.
  final String name;

  /// Box size.
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    SharedAssets.meadowIcon(name),
    width: size,
    height: size,
    excludeFromSemantics: true,
  );
}

/// Section title with its colourful icon.
class MeadowHeader extends StatelessWidget {
  /// Creates the header.
  const MeadowHeader({required this.icon, required this.title, super.key});

  /// Icon name.
  final String icon;

  /// Section title.
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Semantics(
      header: true,
      child: Row(
        children: [
          MeadowIcon(icon, size: 30),
          const SizedBox(width: Space.s + 2),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: displayFont,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: HomePalette.meadowInk,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Thin line between panel sections.
class MeadowDivider extends StatelessWidget {
  /// Creates the divider.
  const MeadowDivider({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 9),
    child: Divider(
      height: 1,
      thickness: 1.5,
      color: HomePalette.meadowDivider,
    ),
  );
}

/// The raised cream shape shared by pills, rows and square buttons.
BoxDecoration meadowRaised(double radius) => BoxDecoration(
  borderRadius: BorderRadius.circular(radius),
  gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [HomePalette.buttonTop, HomePalette.pillCream],
  ),
  border: Border.all(color: HomePalette.troughBorder, width: 1.5),
  boxShadow: const [
    BoxShadow(color: HomePalette.creamEdge, offset: Offset(0, 3)),
    BoxShadow(
      color: HomePalette.cardShadow,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ],
);

/// A segment of a [MeadowSegmented].
class MeadowSegment<T> {
  /// Creates a segment.
  const MeadowSegment(this.value, this.label, {this.icon});

  /// Value chosen by the segment.
  final T value;

  /// Visible label.
  final String label;

  /// Optional icon before the label; takes the label colour.
  final Widget? icon;
}

/// Raised cream bar split into equal segments; the selected one fills its
/// slot in glossy blue.
class MeadowSegmented<T> extends StatelessWidget {
  /// Creates the control.
  const MeadowSegmented({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.height = 44,
    super.key,
  });

  /// The segments.
  final List<MeadowSegment<T>> segments;

  /// The selected value.
  final T selected;

  /// Receives the tapped value.
  final ValueChanged<T> onChanged;

  /// Bar height.
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: meadowRaised(height / 2),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0)
              Container(
                width: 1.5,
                color:
                    segments[i].value == selected ||
                        segments[i - 1].value == selected
                    ? HomePalette.clear
                    : HomePalette.troughBorder,
              ),
            Expanded(
              child: _SegmentButton<T>(
                segment: segments[i],
                selected: segments[i].value == selected,
                onTap: () => onChanged(segments[i].value),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Glossy blue fill of a selected segment.
const _blueFill = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [HomePalette.pillTop, HomePalette.pillBottom],
  ),
  border: Border(
    top: BorderSide(color: HomePalette.pillRim, width: 2),
    bottom: BorderSide(color: HomePalette.pillEdge, width: 3),
  ),
);

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final MeadowSegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: segment.label,
    excludeSemantics: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: selected ? _blueFill : const BoxDecoration(),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Space.xs),
        child: _SegmentLabel(segment: segment, selected: selected),
      ),
    ),
  );
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({required this.segment, required this.selected});

  final MeadowSegment<Object?> segment;
  final bool selected;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (segment.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              size: 24,
              color: selected ? HomePalette.white : HomePalette.meadowInk,
            ),
            child: segment.icon!,
          ),
          const SizedBox(width: Space.s),
        ],
        Text(
          segment.label,
          style: meadowLabelStyle.copyWith(
            fontSize: 17,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? HomePalette.white : HomePalette.meadowInk,
            shadows: selected
                ? const [
                    Shadow(
                      color: HomePalette.playShade,
                      offset: Offset(0, 1.5),
                      blurRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ],
    ),
  );
}

/// A compact choice where the selected option is a floating blue pill
/// inside a cream trough, with an optional leading icon.
class MeadowPillChoice<T> extends StatelessWidget {
  /// Creates the control.
  const MeadowPillChoice({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.leading,
    super.key,
  });

  /// The options.
  final List<MeadowSegment<T>> segments;

  /// The selected value.
  final T selected;

  /// Receives the tapped value.
  final ValueChanged<T> onChanged;

  /// Shown before the options.
  final Widget? leading;

  @override
  Widget build(BuildContext context) => Container(
    height: 50,
    padding: const EdgeInsets.all(4),
    decoration: meadowRaised(25),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.s),
            child: leading,
          ),
        Container(
          decoration: BoxDecoration(
            color: HomePalette.trough,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: HomePalette.troughBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final s in segments)
                Semantics(
                  button: true,
                  selected: s.value == selected,
                  label: s.label,
                  excludeSemantics: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(s.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      constraints: const BoxConstraints(minWidth: 96),
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Space.m,
                      ),
                      decoration: s.value == selected
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: _blueFill.gradient,
                              border: Border.all(
                                color: HomePalette.pillEdge,
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: HomePalette.pillGlow,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            )
                          : const BoxDecoration(),
                      child: _SegmentLabel(
                        segment: s,
                        selected: s.value == selected,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A cream row with an icon, a title and a blue switch.
class MeadowSwitchRow extends StatelessWidget {
  /// Creates the row.
  const MeadowSwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Icon name.
  final String icon;

  /// Row title.
  final String title;

  /// Current value.
  final bool value;

  /// Receives the flipped value.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    label: title,
    excludeSemantics: true,
    onTap: () => onChanged(!value),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Container(
        height: 44,
        padding: const EdgeInsets.only(left: Space.m, right: 5),
        decoration: meadowRaised(22),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(child: MeadowIcon(icon, size: 28)),
            ),
            const SizedBox(width: Space.m),
            Expanded(child: Text(title, style: meadowLabelStyle)),
            _MeadowSwitch(value: value),
          ],
        ),
      ),
    ),
  );
}

class _MeadowSwitch extends StatelessWidget {
  const _MeadowSwitch({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    width: 56,
    height: 32,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: value ? null : HomePalette.switchTrackInactive,
      gradient: value ? _blueFill.gradient : null,
      border: Border.all(
        color: value ? HomePalette.pillEdge : HomePalette.troughBorder,
        width: 1.5,
      ),
    ),
    child: AnimatedAlign(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 23,
        height: 23,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: HomePalette.white,
          boxShadow: [
            BoxShadow(
              color: HomePalette.cardShadow,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shrinks a little while pressed.
class MeadowPressable extends StatefulWidget {
  /// Creates the wrapper.
  const MeadowPressable({required this.child, this.onTap, super.key});

  /// Called on tap; null disables it.
  final VoidCallback? onTap;

  /// Content.
  final Widget child;

  @override
  State<MeadowPressable> createState() => _MeadowPressableState();
}

class _MeadowPressableState extends State<MeadowPressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap != null) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTapDown: (_) => _set(true),
    onTapUp: (_) => _set(false),
    onTapCancel: () => _set(false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _down ? 0.95 : 1,
      duration: const Duration(milliseconds: 100),
      child: widget.child,
    ),
  );
}

/// Raised cream square (or circle) button holding an icon.
class MeadowIconButton extends StatelessWidget {
  /// Creates the button.
  const MeadowIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 52,
    this.circle = false,
    super.key,
  });

  /// Icon content.
  final Widget icon;

  /// Accessible label (also the tooltip).
  final String label;

  /// Called on tap; null disables the button.
  final VoidCallback? onTap;

  /// Width and height.
  final double size;

  /// Round instead of rounded-square.
  final bool circle;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: MeadowPressable(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.45 : 1,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: meadowRaised(circle ? size / 2 : size * 0.3),
            child: IconTheme(
              data: IconThemeData(color: HomePalette.navy, size: size * 0.5),
              child: icon,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Big glossy blue button with a play triangle, flanked by little orange
/// bursts.
class MeadowStartButton extends StatelessWidget {
  /// Creates the button.
  const MeadowStartButton({
    required this.onTap,
    this.label = 'Start',
    super.key,
  });

  /// Called on tap.
  final VoidCallback onTap;

  /// Button label.
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const MeadowBurst(mirror: true),
      const SizedBox(width: Space.xs),
      Expanded(
        child: Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: MeadowPressable(
            onTap: onTap,
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
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
                    color: HomePalette.pillEdge,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: HomePalette.playGlow,
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomPaint(
                    size: Size(26, 30),
                    painter: _PlayTriangle(),
                  ),
                  const SizedBox(width: Space.m),
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: displayFont,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: HomePalette.white,
                      shadows: [
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
            ),
          ),
        ),
      ),
      const SizedBox(width: Space.xs),
      const MeadowBurst(),
    ],
  );
}

/// Three short orange strokes radiating outwards, like a little "ta-da".
class MeadowBurst extends StatelessWidget {
  /// Creates the burst; [mirror] points it left.
  const MeadowBurst({this.mirror = false, this.size = 22, super.key});

  /// Whether the strokes point left.
  final bool mirror;

  /// Box size.
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: mirror,
      child: CustomPaint(size: Size(size, size * 1.4), painter: _Burst()),
    ),
  );
}

class _Burst extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = HomePalette.burst
      ..strokeWidth = size.width * 0.16
      ..strokeCap = StrokeCap.round;
    final c = Offset(0, size.height / 2);
    for (final a in [-0.75, 0.0, 0.75]) {
      final d = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(
        c + d * size.width * 0.35,
        c + d * size.width * 0.9,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_Burst oldDelegate) => false;
}

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
    canvas
      ..drawPath(
        path.shift(const Offset(0, 2)),
        Paint()
          ..color = HomePalette.playShadeSoft
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      )
      ..drawPath(
        path,
        Paint()
          ..color = HomePalette.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = inset * 2
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawPath(path, Paint()..color = HomePalette.white);
  }

  @override
  bool shouldRepaint(_PlayTriangle oldDelegate) => false;
}

/// The 2 / 3 / 4 players bar of Player Setup.
class MeadowPlayerCount extends StatelessWidget {
  /// Creates the bar.
  const MeadowPlayerCount({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Selected number of players.
  final int selected;

  /// Receives the tapped number.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => MeadowSegmented<int>(
    height: 48,
    selected: selected,
    onChanged: onChanged,
    segments: [
      for (final n in [2, 3, 4])
        MeadowSegment(n, '$n', icon: const Icon(Icons.groups_rounded)),
    ],
  );
}

/// A raised cream row with a thumbnail, a title, a hint and a chevron.
class MeadowChoiceRow extends StatelessWidget {
  /// Creates the row.
  const MeadowChoiceRow({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  /// Square picture at the start.
  final Widget thumbnail;

  /// Main line.
  final String title;

  /// Hint below the title.
  final String subtitle;

  /// Called on tap.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$title, $subtitle',
    excludeSemantics: true,
    child: MeadowPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          Space.m,
          Space.m,
          Space.s,
          Space.m,
        ),
        decoration: meadowRaised(22),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: HomePalette.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: HomePalette.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: thumbnail,
              ),
            ),
            const SizedBox(width: Space.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: displayFont,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: HomePalette.meadowInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: bodyFont,
                      fontSize: 13.5,
                      color: HomePalette.meadowInk,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: HomePalette.meadowInk,
            ),
          ],
        ),
      ),
    ),
  );
}
