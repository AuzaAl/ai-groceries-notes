// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GroceryList)
final groceryListProvider = GroceryListProvider._();

final class GroceryListProvider
    extends $AsyncNotifierProvider<GroceryList, List<GroceryItem>> {
  GroceryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryListHash();

  @$internal
  @override
  GroceryList create() => GroceryList();
}

String _$groceryListHash() => r'0d674178cd7c4bdc5e268ca79e5ac0e2dc455f0f';

abstract class _$GroceryList extends $AsyncNotifier<List<GroceryItem>> {
  FutureOr<List<GroceryItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<GroceryItem>>, List<GroceryItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<GroceryItem>>, List<GroceryItem>>,
              AsyncValue<List<GroceryItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
