import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/grocery_item.dart';
import '../services/grocery_api_service.dart';

part 'grocery_provider.g.dart';

final groceryApiServiceProvider = Provider((ref) => GroceryApiService());

@riverpod
class GroceryList extends _$GroceryList {
  @override
  Future<List<GroceryItem>> build() async {
    return [];
  }

  Future<void> extractFromUrl(String url) async {
    state = const AsyncValue.loading();
    try {
      final apiService = ref.read(groceryApiServiceProvider);
      final result = await apiService.extractIngredients(url);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class DebugExtractedItemsNotifier extends Notifier<List<GroceryItem>> {
  @override
  List<GroceryItem> build() => [];

  void setItems(List<GroceryItem> items) => state = items;
  void clear() => state = [];
}

final debugExtractedItemsProvider = NotifierProvider<DebugExtractedItemsNotifier, List<GroceryItem>>(
  DebugExtractedItemsNotifier.new,
);

class DebugErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setError(String? error) => state = error;
  void clear() => state = null;
}

final debugErrorProvider = NotifierProvider<DebugErrorNotifier, String?>(
  DebugErrorNotifier.new,
);

class DebugLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool loading) => state = loading;
}

final debugLoadingProvider = NotifierProvider<DebugLoadingNotifier, bool>(
  DebugLoadingNotifier.new,
);