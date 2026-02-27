import 'package:flutter/material.dart';

enum ButtonStyleVariant { primary, secondary }
enum ButtonSizeVariant { large, medium, small }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonStyleVariant style;
  final ButtonSizeVariant size;
  final bool isDisabled;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = ButtonStyleVariant.primary, // default
    this.size = ButtonSizeVariant.large,     // default
    this.isDisabled = false,
    this.isLoading = false,
  });

  // ===== STYLE CONFIGURATION =====

  Color _backgroundColor() {
    switch (style) {
      case ButtonStyleVariant.primary:
        return const Color(0xFF2938AD);
      case ButtonStyleVariant.secondary:
        return Colors.transparent;
    }
  }

  Color _textColor() {
    switch (style) {
      case ButtonStyleVariant.primary:
        return Colors.white;
      case ButtonStyleVariant.secondary:
        return const Color(0xFF2938AD);
    }
  }

  BorderSide _border() {
    if (style == ButtonStyleVariant.secondary) {
      return const BorderSide(color: Color(0xFF2938AD), width: 2);
    }
    return BorderSide.none;
  }

  double _height() {
    switch (size) {
      case ButtonSizeVariant.large:
        return 63;
      case ButtonSizeVariant.medium:
        return 50;
      case ButtonSizeVariant.small:
        return 40;
    }
  }

  EdgeInsets _padding() {
    switch (size) {
      case ButtonSizeVariant.large:
        return const EdgeInsets.symmetric(horizontal: 24);
      case ButtonSizeVariant.medium:
        return const EdgeInsets.symmetric(horizontal: 20);
      case ButtonSizeVariant.small:
        return const EdgeInsets.symmetric(horizontal: 16);
    }
  }

  TextStyle _textStyle() {
    switch (size) {
      case ButtonSizeVariant.large:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
      case ButtonSizeVariant.medium:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
      case ButtonSizeVariant.small:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;

    return Opacity(
      opacity: disabled ? 0.6 : 1.0, // Disabled appearance
      child: SizedBox(
        height: _height(),
        child: Material(
          color: _backgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: _border(),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: disabled ? null : onTap,
            child: Padding(
              padding: _padding(),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: _textStyle().copyWith(color: _textColor()),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
