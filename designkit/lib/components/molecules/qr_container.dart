import 'dart:ui';
import 'package:flutter/material.dart';

class QrContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String popupTitle;
  final String qrData;
  final IconData icon;
  final Color accentColor;
  final double width;
  final double height;
  final double blur;
  final double opacity;

  const QrContainer({
    super.key,
    required this.title,
    required this.subtitle,
    this.popupTitle = "Scan QR Code",
    this.qrData = "",
    this.icon = Icons.qr_code_2,
    this.accentColor = Colors.black54,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
  });

  void _showQrPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    popupTitle,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Icon(icon, size: 180, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Dismiss",
                      style: TextStyle(fontSize: 20),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmall = constraints.maxWidth < 450;
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showQrPopup(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 12 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9).withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withAlpha(20), // 0.08 * 255
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildIconTile(isVerySmall),
                      SizedBox(width: isVerySmall ? 10 : 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isVerySmall ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isVerySmall ? 14 : 17,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconTile(bool isSmall) {
    final double size = isSmall ? 55 : 70;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2.5,
        ),
      ),
      child: Center(
        child: Icon(
          icon, 
          size: isSmall ? 35 : 45, 
          color: accentColor,
        ),
      ),
    );
  }
}
