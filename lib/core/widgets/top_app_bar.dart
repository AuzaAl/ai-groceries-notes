import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showLogo;

  const TopAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showLogo)
            Center(
              child: SvgPicture.asset('assets/icons/Logo.svg', height: 35),
            ),
          if (showBackButton)
            Positioned(
              left: 17,
              child: GestureDetector(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 24,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                letterSpacing: 0.03,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
