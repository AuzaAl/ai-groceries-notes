import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/grocery_provider.dart';

class GroceryNotesScreen extends ConsumerStatefulWidget {
  const GroceryNotesScreen({super.key});

  @override
  ConsumerState<GroceryNotesScreen> createState() => _GroceryNotesScreenState();
}

class _GroceryNotesScreenState extends ConsumerState<GroceryNotesScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _extractIngredients() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      ref.read(groceryListProvider.notifier).extractFromUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groceryState = ref.watch(groceryListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF061B0E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'GroceryNotes',
          style: TextStyle(
            color: Color(0xFF061B0E),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _urlController,
                      style: const TextStyle(color: Color(0xFF061B0E)),
                      decoration: const InputDecoration(
                        hintText: 'Paste YouTube Link',
                        hintStyle: TextStyle(color: Color(0xFF868889)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: groceryState.isLoading ? null : _extractIngredients,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E6953),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ekstrak Bahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: groceryState.when(
                loading: () => const Center(
                  child: CupertinoActivityIndicator(color: Color(0xFF4E6953)),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No ingredients extracted yet.',
                        style: TextStyle(color: Color(0xFF868889)),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Color(0xFF061B0E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'PlusJakartaSans',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} ${item.unit}',
                                    style: const TextStyle(
                                      color: Color(0xFF434843),
                                      fontSize: 14,
                                      fontFamily: 'PlusJakartaSans',
                                    ),
                                  ),
                                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.notes!,
                                      style: const TextStyle(
                                        color: Color(0xFF868889),
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'PlusJakartaSans',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEEEB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  color: Color(0xFF434843),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'PlusJakartaSans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}