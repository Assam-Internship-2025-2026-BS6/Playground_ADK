import 'package:flutter/material.dart' hide Checkbox;

class Checkbox extends StatefulWidget {
  final bool value;
  final String? label;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onPressed;
  final bool disabled;
  final Color activeColor;
  final Color labelColor;
  final double size;
  final Offset offset;

  const Checkbox({
    super.key,
    required this.value,
    this.label,
    this.onChanged,
    this.onPressed,
    this.disabled = false,
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = const Color(0xFF1E1E4C),
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250), // Slightly longer for smoother feel
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Professional pop effect
      ),
    );
    if (_isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _isSelected = widget.value;
        if (_isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  void _handleTap() {
    if (widget.disabled) return;
    setState(() {
      _isSelected = !_isSelected;
      if (_isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onChanged?.call(_isSelected);
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.disabled 
        ? widget.activeColor.withValues(alpha: 0.3) 
        : widget.activeColor;
        
    return Transform.translate(
      offset: widget.offset,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent, // Placeholder for ripple container if needed
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.scale(
              scale: widget.size,
              alignment: Alignment.centerLeft, // Alignment centerLeft for natural expansion
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Border
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isSelected ? activeColor : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: _isSelected ? activeColor : Colors.white,
                          boxShadow: _isSelected && !widget.disabled
                              ? [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                      ),
                      // Checkmark
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 14),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        color: widget.disabled ? Colors.grey : widget.labelColor,
                        fontSize: 17, // Slightly larger for professional look
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
