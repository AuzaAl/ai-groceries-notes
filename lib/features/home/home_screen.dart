import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/grocery_item.dart';
import '../../providers/grocery_provider.dart';
import '../../core/widgets/top_app_bar.dart';
import '../../core/widgets/bottom_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(debugExtractedItemsProvider);
    final error = ref.watch(debugErrorProvider);
    final isLoading = ref.watch(debugLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const TopAppBar(
              title: '',
              showBackButton: false,
              showLogo: true,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildDebugPanel(items, error, isLoading)),
            const GroceryBottomAppBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugPanel(
    List<GroceryItem> items,
    String? error,
    bool isLoading,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debug: Extracted Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildContent(items, error, isLoading)),
        ],
      ),
    );
  }

  Widget _buildContent(List<GroceryItem> items, String? error, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4E6953)),
      );
    }

    if (error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF3A1C1C),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF6B3A3A)),
        ),
        child: Text(
          'Error: $error',
          style: const TextStyle(
            color: Color(0xFFFF6B6B),
            fontSize: 12,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No data yet.\nTap the button below and paste a YouTube link.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 12,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3C),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 10,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${item.quantity} ${item.unit}',
                style: const TextStyle(
                  color: Color(0xFFAEAEB2),
                  fontSize: 12,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
              if (item.notes != null && item.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.notes!,
                  style: const TextStyle(
                    color: Color(0xFF636366),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}


