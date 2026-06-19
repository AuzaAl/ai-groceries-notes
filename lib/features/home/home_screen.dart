import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/grocery_item.dart';
import '../../providers/grocery_provider.dart';
import '../ai_link/recipe_link_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 15),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildProgressCard(),
                const SizedBox(height: 20),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildTodayListSection(groceryState),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getGreeting()}, Allan',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF061B0E),
              fontFamily: 'PlusJakartaSans',
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Ready for today\'s shopping?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF434843),
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: Color(0xFF4E6953), size: 20),
            SizedBox(width: 12),
            Text(
              'Search ingredient, recipe, archive...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF868889),
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -30,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Icons.eco,
                  size: 180,
                  color: const Color(0xFF4E6953).withValues(alpha: 0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Progress',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF061B0E),
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildStatColumn('12', 'PURCHASED'),
                      _buildDivider(),
                      _buildStatColumn('6', 'REMAINING', isBrown: true),
                      _buildDivider(),
                      _buildStatColumn('69%', 'Progress', isBrown: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isBrown = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isBrown
                  ? const Color(0xFF4E1C02)
                  : const Color(0xFF061B0E),
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF434843),
              fontFamily: 'PlusJakartaSans',
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFC3C8C1).withValues(alpha: 0.5),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.link,
        label: 'Recipe Link',
        bgColor: const Color(0xFFC9E7CC),
        iconColor: const Color(0xFF4E6953),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RecipeLinkScreen(),
            ),
          );
        },
      ),
      _QuickAction(
        icon: Icons.note_alt_outlined,
        label: 'My Notes',
        bgColor: const Color(0xFFC9E7CC),
        iconColor: const Color(0xFF4E6953),
      ),
      _QuickAction(
        icon: Icons.add_circle_outline,
        label: 'Add Manual',
        bgColor: const Color(0xFFC9E7CC),
        iconColor: const Color(0xFF4E6953),
      ),
      _QuickAction(
        icon: Icons.archive_outlined,
        label: 'Archive',
        bgColor: const Color(0xFFFFDBCD),
        iconColor: const Color(0xFF360F00),
      ),
    ];

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildActionButton(action);
        },
      ),
    );
  }

  Widget _buildActionButton(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: SizedBox(
        width: 82,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 48,
              decoration: BoxDecoration(
                color: action.bgColor,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Icon(action.icon, color: action.iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF061B0E),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayListSection(AsyncValue<List<GroceryItem>> groceryState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Today\'s\nEssentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF061B0E),
                        fontFamily: 'PlusJakartaSans',
                        height: 1.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Text(
                          'View Full List',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A654F),
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFF4A654F),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              groceryState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Color(0xFF4E6953)),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No items yet. Add ingredients!',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No items yet. Add ingredients!',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                      ),
                    );
                  }
                  final previewItems = items.take(3).toList();
                  return Column(
                    children: previewItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isChecked = item.isChecked;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < previewItems.length - 1 ? 12 : 0,
                        ),
                        child: _buildListItem(item, isChecked),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(GroceryItem item, bool isChecked) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isChecked ? const Color(0xFFEFEEEB) : const Color(0xFFFBF9F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked ? const Color(0xFF4A654F) : Colors.transparent,
              border: Border.all(
                color: isChecked
                    ? const Color(0xFF4A654F)
                    : const Color(0xFF737973),
                width: 2,
              ),
            ),
            child: isChecked
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1B1C1A),
                fontFamily: 'PlusJakartaSans',
                decoration: isChecked ? TextDecoration.lineThrough : null,
                decorationColor: const Color(0xFF1B1C1A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isChecked
                  ? const Color(0xFFEFEEEB)
                  : const Color(0xFFEFEEEB),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              '${item.quantity.toInt()} ${item.unit}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF434843),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3F0).withValues(alpha: 0.90),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border.all(
                  color: const Color(0xFFC3C8C1).withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(
                        0,
                        Icons.calendar_today_outlined,
                        Icons.calendar_today,
                        'Home',
                      ),
                      _buildNavItem(1, Icons.edit_outlined, Icons.edit, 'Home'),
                      SizedBox(
                        width: 80,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RecipeLinkScreen(),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.link,
                                size: 20,
                                color: Color(0xFF434843),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Recipe Link',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4E6953),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildNavItem(
                        3,
                        Icons.explore_outlined,
                        Icons.explore,
                        'Discover',
                      ),
                      _buildNavItem(
                        4,
                        Icons.person_outline,
                        Icons.person,
                        'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 52,
            left: 0,
            right: 0,
            child: Center(child: _buildCenterFab()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? const Color(0xFF4E6953) : const Color(0xFF434843),
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4E6953),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterFab() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RecipeLinkScreen(),
          ),
        );
      },
      child: Container(
        width: 72,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFBBE9C0),
          borderRadius: BorderRadius.circular(14),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.transparent,
              Colors.transparent,
              Colors.transparent,
            ],
            stops: const [0.0, 0.2, 0.8, 1.0],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.link, color: Color(0xFF4E6953), size: 30)],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });
}
