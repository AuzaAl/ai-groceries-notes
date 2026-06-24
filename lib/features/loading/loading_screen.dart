import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/grocery_provider.dart';
import '../../services/grocery_api_service.dart';
import '../groceries/screens/grocery_notes_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String url;

  const LoadingScreen({super.key, required this.url});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _rotationController;
  late AnimationController _dotsController;
  late AnimationController _burstController;

  late Animation<double> _entryFade;
  late Animation<double> _entryScale;
  late Animation<double> _burstScale;
  late Animation<double> _burstFade;

  String _dots = '';
  bool _navigating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startGenerating();
  }

  void _initAnimations() {
    // Entry animation: fade in + scale up
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _entryFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _entryScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    // Star rotation: continuous gentle spin
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Dots animation: cycles through ".", "..", "..."
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Burst animation: star scales up on completion
    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _burstScale = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _burstController, curve: Curves.easeIn));
    _burstFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _burstController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Listen to dots animation
    _dotsController.addListener(_updateDots);

    // Start entry animation
    Future.microtask(() => _entryController.forward());
  }

  void _updateDots() {
    if (!mounted || _navigating) return;
    final progress = _dotsController.value;
    setState(() {
      if (progress < 0.33) {
        _dots = '.';
      } else if (progress < 0.66) {
        _dots = '..';
      } else {
        _dots = '...';
      }
    });
  }

  Future<void> _startGenerating() async {
    try {
      final apiService = GroceryApiService();
      final items = await apiService.extractIngredients(widget.url);

      if (!mounted || _navigating) return;

      // Update providers
      final container = ProviderScope.containerOf(context);
      container.read(debugExtractedItemsProvider.notifier).setItems(items);
      container.read(debugErrorProvider.notifier).clear();

      // Trigger burst animation
      await _playBurstAnimation();

      if (!mounted) return;
      _navigateToGrocery();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _playBurstAnimation() async {
    _navigating = true;
    _rotationController.stop();
    await _burstController.forward();
  }

  void _navigateToGrocery() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GroceryNotesScreen()),
    );
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _rotationController.dispose();
    _dotsController.removeListener(_updateDots);
    _dotsController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _entryController,
        builder: (context, child) {
          return Opacity(
            opacity: _entryFade.value,
            child: Transform.scale(scale: _entryScale.value, child: child),
          );
        },
        child: Stack(
          children: [
            // Decorative sparkle pattern background
            _buildSparklePattern(),

            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated star icon
                  _buildStarIcon(),
                  const SizedBox(height: 20),
                  // Generating text with animated dots
                  _buildGeneratingText(),
                ],
              ),
            ),

            // Error state
            if (_error != null) _buildErrorState(),
          ],
        ),
      ),
    );
  }

  Widget _buildStarIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _burstController]),
      builder: (context, child) {
        final rotation = _burstController.isAnimating
            ? _burstScale.value
            : _rotationController.value * 2 * math.pi;
        final scale = _burstController.isAnimating ? _burstScale.value : 1.0;
        final opacity = _burstController.isAnimating ? _burstFade.value : 1.0;

        return Transform.rotate(
          angle: _burstController.isAnimating ? 0 : rotation,
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: SvgPicture.asset(
                'assets/images/WhiteStar_Icon.svg',
                width: 80,
                height: 80,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneratingText() {
    return Text(
      'Generating your notes$_dots',
      style: const TextStyle(
        color: Color(0xFF7B7B7B),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'PlusJakartaSans',
      ),
    );
  }

  Widget _buildSparklePattern() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Opacity(
          opacity: 0.15,
          child: Image.asset(
            'assets/images/svgpattern.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Positioned(
      bottom: 80,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(
                color: Color(0xFFFF6B6B),
                fontSize: 13,
                fontFamily: 'PlusJakartaSans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _goBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

