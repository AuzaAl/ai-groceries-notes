import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  double _dragOffset = 0;
  double _maxDrag = 0;
  bool _isDragging = false;
  double _buttonScale = 1.0;

  static const double _thumbSize = 50;
  static const double _trackHeight = 60;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    
    // Fade-up animation for tomato image
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    
    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  double get _displayOffset {
    if (_slideController.isAnimating || _slideController.isCompleted) {
      return _slideController.value * _maxDrag;
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
    if (ratio >= 0.75) {
      _slideController.value = ratio;
      _slideController.forward().then((_) => _navigateToHome());
    } else {
      _slideController.value = ratio;
      _slideController.reverse().then((_) {
        setState(() => _dragOffset = 0);
      });
    }
    setState(() {});
  }

  void _onButtonTapDown(TapDownDetails details) {
    setState(() => _buttonScale = 0.95);
    HapticFeedback.selectionClick();
  }

  void _onButtonTapUp(TapUpDetails details) {
    setState(() => _buttonScale = 1.0);
  }

  void _onButtonTapCancel() {
    setState(() => _buttonScale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient overlay (subtle)
            Positioned(
              left: -25,
              bottom: 130,
              right: -25,
              height: 432,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      const Color(0xFF673434).withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            
            // Main content
            Column(
              children: [
                const SizedBox(height: 20),
                
                // Tomato image with fade-up animation
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Image.asset(
                              'assets/images/tomato_notes.png',
                              height: 280,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Title and description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        'Belanja Dengan Asisten Ai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E0E0E),
                          fontFamily: 'PlusJakartaSans',
                          height: 1.09,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Biarkan AI menyusun daftar belanjamu secara presisi dan otomatis.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B6B6B),
                          fontFamily: 'Inter',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Slide button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 59),
                  child: _buildSlideButton(),
                ),
                
                const SizedBox(height: 51),
              ],
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
          onTapDown: _onButtonTapDown,
          onTapUp: _onButtonTapUp,
          onTapCancel: _onButtonTapCancel,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedScale(
            scale: _buttonScale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Container(
              height: _trackHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF673434),
                borderRadius: BorderRadius.circular(_trackHeight / 2),
                border: Border.all(
                  color: const Color(0xFF673434).withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF673434).withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // "Get Started" text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedOpacity(
                        opacity: _displayOffset > _maxDrag * 0.5 ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: const Color(0xFFDDDDDD),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PlusJakartaSans',
                            letterSpacing: 0.42,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Sliding thumb button
                  Positioned(
                    left: _displayOffset + 5,
                    top: 5,
                    child: Container(
                      width: _thumbSize,
                      height: _thumbSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: const Color(0xFFDDDDDD),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
