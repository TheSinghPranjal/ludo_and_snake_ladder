import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:flutter/material.dart';

/// A standard page: app bar with back, and a centred, width-limited body.
class PageFrame extends StatelessWidget {
  /// Creates a page.
  const PageFrame({
    required this.title,
    required this.child,
    this.actions = const [],
    this.scroll = true,
    this.bottom,
    super.key,
  });

  /// App bar title.
  final String title;

  /// Page content.
  final Widget child;

  /// App bar actions.
  final List<Widget> actions;

  /// Whether the body scrolls.
  final bool scroll;

  /// Widget pinned below the body, e.g. a Start button.
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Space.maxContent),
        child: scroll
            ? SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Space.l,
                  Space.s,
                  Space.l,
                  Space.xl,
                ),
                child: child,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.l),
                child: child,
              ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        leading: canPop
            ? IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const AppIcon('back'),
              )
            : null,
        actions: actions,
      ),
      body: SafeArea(top: false, child: body),
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Space.maxContent),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Space.l,
                      Space.s,
                      Space.l,
                      Space.m,
                    ),
                    child: SizedBox(width: double.infinity, child: bottom),
                  ),
                ),
              ),
            ),
    );
  }
}

/// A small heading above a group of settings or seats.
class SectionTitle extends StatelessWidget {
  /// Creates a heading.
  const SectionTitle(this.text, {super.key});

  /// Heading text.
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Space.l, bottom: Space.s),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

/// A large menu row: icon, title and optional subtitle.
class MenuTile extends StatelessWidget {
  /// Creates a row.
  const MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.primary = false,
    super.key,
  });

  /// Icon name.
  final String icon;

  /// Main label.
  final String title;

  /// Second line.
  final String? subtitle;

  /// Called on tap; null disables the row.
  final VoidCallback? onTap;

  /// Whether this is the screen's main action.
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = primary ? scheme.onPrimary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.m),
      child: Material(
        color: primary ? scheme.primary : scheme.surface,
        elevation: primary ? 2 : 1,
        shadowColor: scheme.shadow,
        borderRadius: BorderRadius.circular(Space.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Space.radius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.l,
                vertical: Space.m,
              ),
              child: Row(
                children: [
                  AppIcon(icon, size: 28, color: fg),
                  const SizedBox(width: Space.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: fg),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: primary ? fg : scheme.onSurfaceVariant,
                            ),
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
    );
  }
}
