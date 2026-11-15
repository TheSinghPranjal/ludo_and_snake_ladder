// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global settings. Changes apply at once to audio and haptics and are
/// saved.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Global settings. Changes apply at once to audio and haptics and are
/// saved.
final class SettingsControllerProvider
    extends $NotifierProvider<SettingsController, AppSettings> {
  /// Global settings. Changes apply at once to audio and haptics and are
  /// saved.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$settingsControllerHash() =>
    r'e3c662ee502f9677d3493c6311ce5a174e0216cf';

/// Global settings. Changes apply at once to audio and haptics and are
/// saved.

abstract class _$SettingsController extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The player's profile.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// The player's profile.
final class ProfileControllerProvider
    extends $NotifierProvider<ProfileController, Profile> {
  /// The player's profile.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Profile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Profile>(value),
    );
  }
}

String _$profileControllerHash() => r'9dae278f34c0f0188c372e676b56e351399a8e2f';

/// The player's profile.

abstract class _$ProfileController extends $Notifier<Profile> {
  Profile build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Profile, Profile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Profile, Profile>,
              Profile,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Lifetime statistics per game.

@ProviderFor(StatsController)
final statsControllerProvider = StatsControllerProvider._();

/// Lifetime statistics per game.
final class StatsControllerProvider
    extends $NotifierProvider<StatsController, Map<GameType, GameStats>> {
  /// Lifetime statistics per game.
  StatsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsControllerHash();

  @$internal
  @override
  StatsController create() => StatsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<GameType, GameStats> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<GameType, GameStats>>(value),
    );
  }
}

String _$statsControllerHash() => r'03f78e0f3e6c975e3dd604ae7a3a279477f6df1d';

/// Lifetime statistics per game.

abstract class _$StatsController extends $Notifier<Map<GameType, GameStats>> {
  Map<GameType, GameStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<GameType, GameStats>, Map<GameType, GameStats>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<GameType, GameStats>, Map<GameType, GameStats>>,
              Map<GameType, GameStats>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Unlocked content ids, such as boards. Never re-locked.

@ProviderFor(UnlocksController)
final unlocksControllerProvider = UnlocksControllerProvider._();

/// Unlocked content ids, such as boards. Never re-locked.
final class UnlocksControllerProvider
    extends $NotifierProvider<UnlocksController, Set<String>> {
  /// Unlocked content ids, such as boards. Never re-locked.
  UnlocksControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlocksControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlocksControllerHash();

  @$internal
  @override
  UnlocksController create() => UnlocksController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$unlocksControllerHash() => r'f0ebb980292186906599d1b3ac478fa33c5eb598';

/// Unlocked content ids, such as boards. Never re-locked.

abstract class _$UnlocksController extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The saved local game of each game, one slot per game.

@ProviderFor(SavesController)
final savesControllerProvider = SavesControllerProvider._();

/// The saved local game of each game, one slot per game.
final class SavesControllerProvider
    extends $NotifierProvider<SavesController, Map<GameType, SavedGame>> {
  /// The saved local game of each game, one slot per game.
  SavesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savesControllerHash();

  @$internal
  @override
  SavesController create() => SavesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<GameType, SavedGame> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<GameType, SavedGame>>(value),
    );
  }
}

String _$savesControllerHash() => r'b6fbec5f4356acd01587d84534a32f4c21abd2e2';

/// The saved local game of each game, one slot per game.

abstract class _$SavesController extends $Notifier<Map<GameType, SavedGame>> {
  Map<GameType, SavedGame> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<GameType, SavedGame>, Map<GameType, SavedGame>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<GameType, SavedGame>, Map<GameType, SavedGame>>,
              Map<GameType, SavedGame>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Saved rule settings per game, encoded with each game's config codec.

@ProviderFor(RulesController)
final rulesControllerProvider = RulesControllerProvider._();

/// Saved rule settings per game, encoded with each game's config codec.
final class RulesControllerProvider
    extends
        $NotifierProvider<
          RulesController,
          Map<GameType, Map<String, dynamic>>
        > {
  /// Saved rule settings per game, encoded with each game's config codec.
  RulesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rulesControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rulesControllerHash();

  @$internal
  @override
  RulesController create() => RulesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<GameType, Map<String, dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<GameType, Map<String, dynamic>>>(
        value,
      ),
    );
  }
}

String _$rulesControllerHash() => r'6ec6ad0fa9a38ac6ad23d3ba64151d477fd3ae14';

/// Saved rule settings per game, encoded with each game's config codec.

abstract class _$RulesController
    extends $Notifier<Map<GameType, Map<String, dynamic>>> {
  Map<GameType, Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<GameType, Map<String, dynamic>>,
              Map<GameType, Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<GameType, Map<String, dynamic>>,
                Map<GameType, Map<String, dynamic>>
              >,
              Map<GameType, Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
