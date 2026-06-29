import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/orb_background.dart';
import '../../../core/widgets/bottom_app_bar.dart';
import '../../../models/grocery_item.dart';
import '../../../providers/grocery_provider.dart';

class GroceryNotesScreen extends ConsumerStatefulWidget {
  const GroceryNotesScreen({super.key});

  @override
  ConsumerState<GroceryNotesScreen> createState() => _GroceryNotesScreenState();
}

class _GroceryNotesScreenState extends ConsumerState<GroceryNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRecordingVoice = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getIndonesianDate() {
    final now = DateTime.now();
    final List<String> days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void _showAddManualItemDialog() {
    HapticFeedback.mediumImpact();
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final unitController = TextEditingController(text: 'pcs');
    final categoryController = TextEditingController(text: 'Lain-lain');
    final emojiController = TextEditingController(text: '📦');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Tambah Item Manual', style: AppTextStyles.headingL),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Item',
                    labelStyle: TextStyle(color: ink500),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: green500),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                          labelStyle: TextStyle(color: ink500),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: green500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          labelText: 'Satuan',
                          labelStyle: TextStyle(color: ink500),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: green500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    labelStyle: TextStyle(color: ink500),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: green500),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emojiController,
                  decoration: const InputDecoration(
                    labelText: 'Emoji (Opsional)',
                    labelStyle: TextStyle(color: ink500),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: green500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: ink500)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final qty = double.tryParse(qtyController.text) ?? 1.0;
                final unit = unitController.text.trim();
                final category = categoryController.text.trim();
                final emoji = emojiController.text.trim();

                if (name.isNotEmpty) {
                  final newItem = GroceryItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    quantity: qty,
                    unit: unit,
                    category: category.isNotEmpty ? category : 'Lain-lain',
                    notes: emoji.isNotEmpty ? emoji : '📦',
                    addedAt: DateTime.now(),
                    source: 'manual',
                  );
                  ref
                      .read(debugExtractedItemsProvider.notifier)
                      .addItem(newItem);
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Tambah',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleVoiceInput() {
    HapticFeedback.lightImpact();
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
    });

    if (_isRecordingVoice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mendengarkan suara untuk pencarian...'),
          duration: Duration(seconds: 2),
        ),
      );
      // Simulate voice finding something
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isRecordingVoice) {
          setState(() {
            _isRecordingVoice = false;
            _searchController.text = 'Brokoli';
          });
        }
      });
    }
  }

  Map<String, List<GroceryItem>> _getGroupedItems(List<GroceryItem> items) {
    // Filter items first
    final filtered = items.where((item) {
      final matchesName = item.name.toLowerCase().contains(_searchQuery);
      final matchesCategory = item.category.toLowerCase().contains(
        _searchQuery,
      );
      return matchesName || matchesCategory;
    }).toList();

    // Group items by category
    final Map<String, List<GroceryItem>> grouped = {};
    for (final item in filtered) {
      final cat = item.category.toUpperCase();
      if (!grouped.containsKey(cat)) {
        grouped[cat] = [];
      }
      grouped[cat]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final rawItems = ref.watch(debugExtractedItemsProvider);
    final grouped = _getGroupedItems(rawItems);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Title + Date + Add Button)
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daftar Belanja',
                            style: AppTextStyles.displayLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getIndonesianDate(),
                            style: AppTextStyles.bodyL.copyWith(color: ink500),
                          ),
                        ],
                      ),
                    ),
                    // Translucent Frame 3 add-fill button
                    GestureDetector(
                      onTap: _showAddManualItemDialog,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.4),
                          border: Border.all(color: ink100, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2E7D52,
                              ).withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: green500, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D52).withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 16, right: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: ink300, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: AppTextStyles.bodyL.copyWith(color: ink900),
                          decoration: InputDecoration(
                            hintText: 'Cari item belanja...',
                            hintStyle: AppTextStyles.bodyL.copyWith(
                              color: ink300,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleVoiceInput,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecordingVoice ? green500 : green400,
                          ),
                          child: Center(
                            child: _isRecordingVoice
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 3. Category Sections
              Expanded(
                child: rawItems.isEmpty
                    ? _buildEmptyState()
                    : grouped.isEmpty
                    ? _buildNoResultsState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, catIndex) {
                          final categoryName = grouped.keys.elementAt(catIndex);
                          final categoryItems = grouped[categoryName]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 8.0,
                                  left: 4.0,
                                ),
                                child: Text(
                                  '$categoryName (${categoryItems.length})',
                                  style: AppTextStyles.labelS.copyWith(
                                    color: ink500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ...categoryItems.map((item) {
                                final globalIndex = rawItems.indexOf(item);
                                return _buildGroceryListItem(item, globalIndex);
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const GroceryBottomAppBar(selectedIndex: 3),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Belum ada belanjaan', style: AppTextStyles.headingL),
            const SizedBox(height: 8),
            Text(
              'Tambah item manual atau minta AI buatkan list untuk kamu.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyL.copyWith(color: ink500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Tidak ketemu', style: AppTextStyles.headingL),
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain, atau tambahkan sendiri.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyL.copyWith(color: ink500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientImage(GroceryItem item) {
    final key = item.ingredientKey;
    final fallbackEmoji = (item.notes != null && item.notes!.isNotEmpty && item.source == 'manual')
        ? item.notes!
        : '📦';

    if (key != null && key.isNotEmpty) {
      final url = 'https://www.themealdb.com/images/ingredients/$key.png/small';
      return SizedBox(
        width: 40,
        height: 40,
        child: Image.network(
          url,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Text(fallbackEmoji, style: const TextStyle(fontSize: 28)),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            );
          },
        ),
      );
    }

    return Text(fallbackEmoji, style: const TextStyle(fontSize: 28));
  }

  Widget _buildGroceryListItem(GroceryItem item, int globalIndex) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final notifier = ref.read(debugExtractedItemsProvider.notifier);
        final deletedItem = item;
        final deletedIndex = globalIndex;
        notifier.removeAt(deletedIndex);
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${deletedItem.name} dihapus'),
            backgroundColor: const Color.fromARGB(255, 81, 146, 80),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              textColor: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
                notifier.insertAt(deletedIndex, deletedItem);
              },
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: item.isChecked ? Colors.white : bgSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                255,
                96,
                223,
                153,
              ).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            ref
                .read(debugExtractedItemsProvider.notifier)
                .toggleChecked(globalIndex);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.isChecked ? green500 : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: item.isChecked ? green500 : ink300,
                      width: 1.5,
                    ),
                  ),
                  child: item.isChecked
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),

                // Ingredient Image or Emoji fallback
                _buildIngredientImage(item),
                const SizedBox(width: 12),

                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.headingS.copyWith(
                          color: item.isChecked ? ink500 : ink900,
                          decoration: item.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.category} • Qty: ${item.quantity.toStringAsFixed(0)}${item.unit.isNotEmpty ? ' ${item.unit}' : ''}',
                        style: AppTextStyles.bodyS.copyWith(color: ink500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
