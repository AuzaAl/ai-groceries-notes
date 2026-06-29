import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../../features/home/widgets/ai_notes_bottom_sheet.dart';
import '../../features/loading/loading_screen.dart';
import '../../features/groceries/screens/grocery_notes_screen.dart';
import 'package:flutter/widget_previews.dart';

// Color Tokens
const Color _ink300 = Color(0xFF6B7775);
const Color _green500 = Color(0xFF2E7D52);
const Color _green50 = Color(0xFFF1FAF5);

class GroceryBottomAppBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const GroceryBottomAppBar({
    super.key,
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  @override
  State<GroceryBottomAppBar> createState() => _GroceryBottomAppBarState();
}

class _GroceryBottomAppBarState extends State<GroceryBottomAppBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant GroceryBottomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  void _onTabTapped(int index) {
    if (_selectedIndex != index) {
      HapticFeedback.selectionClick();
      setState(() {
        _selectedIndex = index;
      });
      widget.onTabSelected?.call(index);
    }
  }

  double _getIndicatorLeftPosition(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 5;
    return (index * itemWidth) +
        (itemWidth / 2) -
        24; // 24 is half of pill width (48)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 86 + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        clipBehavior: Clip.none,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgBase, // solid white top — hides dark background
              Color(0xD9FFFFFF), // 85% white bottom
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Smooth sliding indicator pill
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: _getIndicatorLeftPosition(context, _selectedIndex),
              top: 14,
              child: Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  color: _green50,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            // Tab Items
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NavBarItem(
                  icon: 'assets/icons/home.svg',
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onTabTapped(0),
                ),
                _NavBarItem(
                  icon: 'assets/icons/paper.svg',
                  label: 'Recipe',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onTabTapped(1),
                ),
                const _CenterFab(),
                _NavBarItem(
                  icon: 'assets/icons/shopping-basket.svg',
                  label: 'Grocery',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    _onTabTapped(3);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GroceryNotesScreen()),
                    );
                  },
                ),
                _NavBarItem(
                  icon: 'assets/icons/Profile.svg',
                  label: 'Profile',
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onTabTapped(4),
                ),
              ],
            ),
          ],
        ),
      );
  }
}

class _NavBarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 86,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  icon,
                  key: ValueKey<bool>(isSelected),
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? _green500 : _ink300,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? _green500 : _ink300,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterFab extends StatefulWidget {
  const _CenterFab();

  @override
  State<_CenterFab> createState() => _CenterFabState();
}

class _CenterFabState extends State<_CenterFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  Future<void> _onTap() async {
    HapticFeedback.mediumImpact();
    // Modern pulse on tap
    _controller.forward().then((_) {
      _controller.reverse();
    });

    final url = await AiNotesBottomSheet.show(context);
    if (url != null && url.isNotEmpty && mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => LoadingScreen(url: url)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _onTap,
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, -21),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0x4DFFFFFF), // white/30
                          green500.withValues(alpha: 0.15), // subtle green tint
                          const Color(0x1AFFFFFF), // white/10
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      border: Border.all(
                        color: green500.withValues(alpha: 0.25), // green accent border
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A2E7D52),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/StarIcon.svg',
                        width: 32,
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          green500,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@Preview()
Widget previewGroceryBottomAppBar() {
  return const Scaffold(
    bottomNavigationBar: GroceryBottomAppBar(selectedIndex: 0),
  );
}
