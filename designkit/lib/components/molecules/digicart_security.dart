import 'dart:ui';
import 'package:flutter/material.dart';

class DigicartSecurity extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double width;
  final double height;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;

  const DigicartSecurity({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
    this.onTap,
  });

  @override
  State<DigicartSecurity> createState() => _DigicartSecurityState();
}

class _DigicartSecurityState extends State<DigicartSecurity> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
            child: Container(
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9).withValues(alpha: widget.opacity),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isPressed
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Color(0xFF004C8F),
                              fontSize: 19, // Increased from 17
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF004C8F),
                              fontWeight: FontWeight.bold,
                              fontSize: 25, // Increased from 22
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25), // 0.1 * 255
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(widget.imagePath),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
