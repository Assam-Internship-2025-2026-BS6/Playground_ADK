import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;
  final double offsetX;
  final double offsetY;
  final bool showShadow;

  const Logo({
    super.key,
    this.width = 240.0,
    this.height = 31.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/hdfc_logo.png',
                  height: 31.0,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.white24, size: 24),
                ),
                const SizedBox(width: 20),
                Image.asset(
                  'assets/now_logo.png',
                  height: 26.0,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.white24, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
