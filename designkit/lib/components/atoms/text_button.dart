import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as m show Text;

class TextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double fontSize;
  final bool isClickable;
  final bool enableHover;

  const TextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 24,
    this.isClickable = true,
    this.enableHover = true,
  });

  @override
  State<TextButton> createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.color ?? const Color(0xFF283097);
    final bool effectiveClickable = widget.isClickable;

    return MouseRegion(
      cursor: effectiveClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.enableHover && effectiveClickable) {
          setState(() => _isHovering = true);
        }
      },
      onExit: (_) {
        if (widget.enableHover && effectiveClickable) {
          setState(() => _isHovering = false);
        }
      },
      child: GestureDetector(
        onTap: effectiveClickable ? widget.onPressed : null,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: widget.fontSize,
            height: 1.0,
            letterSpacing: 0,
            color: _isHovering ? baseColor.withValues(alpha: 0.8) : baseColor,
            decoration: _isHovering && widget.enableHover
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          child: m.Text(widget.text),
        ),
      ),
    );
  }
}
