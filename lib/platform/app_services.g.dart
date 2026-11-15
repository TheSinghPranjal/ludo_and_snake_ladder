// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's services. The composition root must override this.

@ProviderFor(appServices)
final appServicesProvider = AppServicesProvider._();

/// The app's services. The composition root must override this.

final class AppServicesProvider
    extends $FunctionalProvider<AppServices, AppServices, AppServices>
    with $Provider<AppServices> {
  /// The app's services. The composition root must override this.
  AppServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appServicesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appServicesHash();

  @$internal
  @override
  $ProviderElement<AppServices> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppServices create(Ref ref) {
    return appServices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppServices value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppServices>(value),
    );
  }
}

String _$appServicesHash() => r'fbbacfa4c75501ca5f9bc01237295e2687c1e441';

/// The loaded games.

@ProviderFor(gameCatalog)
final gameCatalogProvider = GameCatalogProvider._();

/// The loaded games.

final class GameCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<GameCatalog>,
          GameCatalog,
          FutureOr<GameCatalog>
        >
    with $FutureModifier<GameCatalog>, $FutureProvider<GameCatalog> {
  /// The loaded games.
  GameCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameCatalogHash();

  @$internal
  @override
  $FutureProviderElement<GameCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GameCatalog> create(Ref ref) {
    return gameCatalog(ref);
  }
}

String _$gameCatalogHash() => r'10c8066ac1e832e0a410dedb614f9764249e882a';
