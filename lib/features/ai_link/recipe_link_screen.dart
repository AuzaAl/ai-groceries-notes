import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/grocery_provider.dart';

class RecipeLinkScreen extends ConsumerStatefulWidget {
  const RecipeLinkScreen({super.key});

  @override
  ConsumerState<RecipeLinkScreen> createState() => _RecipeLinkScreenState();
}

class _RecipeLinkScreenState extends ConsumerState<RecipeLinkScreen> {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD5E9DC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 25),
              Expanded(
                child: _buildContent(groceryState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text(
              '← Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0x434843BF),
                fontFamily: 'PlusJakartaSans',
                height: 24 / 14,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Create Notes From Video',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF061B0E),
              fontFamily: 'PlusJakartaSans',
              height: 36 / 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<dynamic>> groceryState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYouTubeSection(),
          const SizedBox(height: 15),
          _buildInputField(),
          const SizedBox(height: 15),
          _buildDivider(),
          const SizedBox(height: 15),
          Expanded(
            child: _buildNotesArea(groceryState),
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catat dari YouTube',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tempel link YouTube jadi catatan belanja.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF868889),
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E3E3)),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _urlController,
              style: const TextStyle(
                color: Color(0xFF061B0E),
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Search ingredient, recipe, archive...',
                hintStyle: TextStyle(
                  color: Color(0xFF868889),
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _extractIngredients,
            child: Container(
              width: 49,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFC9E7CC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.link,
                color: Color(0xFF4E6953),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Center(
      child: SizedBox(
        width: 264,
        child: Divider(
          color: Color(0x4E695380),
          thickness: 1,
        ),
      ),
    );
  }

  Widget _buildNotesArea(AsyncValue<List<dynamic>> groceryState) {
    return groceryState.when(
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
              'No notes yet. Paste a YouTube link to get started.',
              style: TextStyle(
                color: Color(0xFF868889),
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
    );
  }
}
