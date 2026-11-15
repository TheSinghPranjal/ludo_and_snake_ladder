import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The app widget: theme (System / Light / Dark with a 250 ms cross-fade)
/// and the router.
class DicePartyApp extends ConsumerStatefulWidget {
  /// Creates the app around [router].
  const DicePartyApp({required this.router, super.key});

  /// Navigation.
  final GoRouter router;

  @override
  ConsumerState<DicePartyApp> createState() => _DicePartyAppState();
}

class _DicePartyAppState extends ConsumerState<DicePartyApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(appServicesProvider)
        .audio
        .suspend(suspended: state != AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) {
    final appearance = ref.watch(
      settingsControllerProvider.select((s) => s.appearance),
    );
    final catalog = ref.watch(gameCatalogProvider).value;
    final light = catalog?.themeExtensions(Brightness.light) ?? const [];
    final dark = catalog?.themeExtensions(Brightness.dark) ?? const [];
    return MaterialApp.router(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light, extensions: light),
      darkTheme: buildAppTheme(Brightness.dark, extensions: dark),
      themeMode: switch (appearance) {
        AppearanceMode.system => ThemeMode.system,
        AppearanceMode.light => ThemeMode.light,
        AppearanceMode.dark => ThemeMode.dark,
      },
      themeAnimationDuration: themeFade,
      routerConfig: widget.router,
    );
  }
}
