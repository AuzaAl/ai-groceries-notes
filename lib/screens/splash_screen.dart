import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _dragOffset = 0;
  double _maxDrag = 0;
  bool _isDragging = false;

  static const double _thumbSize = 56;
  static const double _trackHeight = 56;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  double get _displayOffset {
    if (_animController.isAnimating || _animController.isCompleted) {
      return _animController.value * _maxDrag;
    }
    return _dragOffset;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragOffset = (_dragOffset + details.delta.dx).clamp(0, _maxDrag);
    if (!_isDragging) {
      _isDragging = true;
      HapticFeedback.lightImpact();
    }
    setState(() {});
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    final ratio = _dragOffset / _maxDrag;
    if (ratio >= 0.8) {
      _animController.value = ratio;
      _animController.forward().then((_) => _navigateToHome());
    } else {
      _animController.value = ratio;
      _animController.reverse().then((_) {
        setState(() => _dragOffset = 0);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.black,
                ),
                const SizedBox(height: 24),
                Text(
                  'GroceryNotes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'PlusJakartaSans',
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Smart Grocery Shopping',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withAlpha(128),
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 48),
              child: _buildSlideButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxDrag = constraints.maxWidth - _thumbSize;

        return GestureDetector(
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: Container(
            height: _trackHeight,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(_trackHeight / 2),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: _displayOffset > _maxDrag * 0.6 ? 0 : 1,
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      'get started',
                      style: TextStyle(
                        color: Colors.black.withAlpha(153),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PlusJakartaSans',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: _displayOffset,
                  top: 0,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(51),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
