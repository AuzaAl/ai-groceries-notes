import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/orb_background.dart';
import '../../core/widgets/bottom_app_bar.dart';
import '../../providers/ingredient_spotlight_provider.dart';
import 'widgets/note_card.dart';
import 'widgets/ingredient_card.dart';
import 'widgets/ai_suggestion_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _waveAnimation = Tween<double>(begin: 0, end: 0.3).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBase,
      body: OrbBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildGreetingSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AiSuggestionBanner(
                    title: 'AI SUGGESTION',
                    message:
                        'Kamu belum beli susu 5 hari. Mau aku tambahkan ke list?',
                    actionText: 'Tambah ke list →',
                    onAction: () {},
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Catatan terakhir', 'Lihat semua'),
                const SizedBox(height: 12),
                _buildNotesList(),
                const SizedBox(height: 24),
                _buildSectionHeader('Temukan Bahan Baru', 'Lihat semua'),
                const SizedBox(height: 12),
                _buildIngredientList(ref),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const GroceryBottomAppBar(selectedIndex: 0),
    );
  }

  String _getIndonesianDate() {
    final now = DateTime.now();
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    const months = [
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

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat pagi',
            style: AppTextStyles.bodyM.copyWith(color: ink500),
          ),
          const SizedBox(height: 4),
          Text('Auza Alfarizi 👋', style: AppTextStyles.displayLarge),
          const SizedBox(height: 4),
          Text(
            _getIndonesianDate(),
            style: AppTextStyles.bodyL.copyWith(color: ink500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String linkText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headingS.copyWith(color: ink900)),
          Text(
            linkText,
            style: AppTextStyles.labelM.copyWith(
              color: green500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return SizedBox(
      height: 116,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          NoteCard(
            totalItems: 12,
            completedItems: 8,
            noteName: 'Belanja mingguan',
            emoji: '🛒',
          ),
          NoteCard(
            totalItems: 10,
            completedItems: 8,
            noteName: 'Ulang Tahun Adek',
            emoji: '🛒',
          ),
          NoteCard(
            totalItems: 12,
            completedItems: 8,
            noteName: 'Belanja mingguan',
            emoji: '🛒',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 78,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildCategoryChip('Semua', '🛒', true),
          _buildCategoryChip('Sayur', '🥦', false),
          _buildCategoryChip('Buah', '🍎', false),
          _buildCategoryChip('Daging', '🥩', false),
          _buildCategoryChip('Susu', '🥛', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String emoji, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isActive ? bgElevated : bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: isActive ? Border.all(color: green500) : null,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2E7D52).withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.labelS.copyWith(
              color: isActive ? green500 : ink500,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList(WidgetRef ref) {
    final asyncIngredients = ref.watch(ingredientSpotlightProvider);

    return asyncIngredients.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: List.generate(
            4,
            (_) => Container(
              decoration: BoxDecoration(
                color: bgElevated,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ink100),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ),
          ),
        ),
      ),
      error: (e, stack) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Gagal memuat bahan. Cek koneksi internet.',
          style: AppTextStyles.bodyS.copyWith(color: ink500),
        ),
      ),
      data: (ingredients) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: ingredients
              .map(
                (item) => IngredientCard(
                  imageUrl: item.imageUrl,
                  name: item.name,
                  description: item.description,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
