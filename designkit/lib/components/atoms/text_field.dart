import 'package:flutter/material.dart' hide TextField;
import 'package:flutter/material.dart' as m show TextField, TextEditingController, Text;
import 'package:flutter/services.dart';

class TextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? Function(String)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final double? height;
  final bool showErrorText;

  const TextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.width,
    this.height,
    this.showErrorText = true,
  });

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final m.TextEditingController _controller = m.TextEditingController();
  bool _obscureText = true;
  String? _errorText;
  bool _isHovering = false;

  String? _validatePassword(String value) {
    if (value.isEmpty) return null; // Let the custom validator handle empty if needed

    if (value.length < 8) return "Minimum 8 characters required";
    if (value.length > 16) return "Maximum 16 characters allowed";

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return "Use mix of A-Z, a-z, 0-9 & symbols";
    }

    return null;
  }

  void _validate(String value) {
    String? error;

    if (widget.isPassword) {
      debugPrint("Password Field Input: $value");
      error = _validatePassword(value);
    } else {
      debugPrint("Customer ID Field Input: $value");
    }

    if (error == null && widget.validator != null) {
      error = widget.validator!(value);
    }

    setState(() {
      _errorText = error;
    });
  }

  bool get hasError => _errorText != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Don't take extra vertical space
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: _isHovering
                    ? const Color.fromARGB(255, 27, 27, 27).withValues(alpha: 0.05)
                    : const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(30), // Pill shape
                border: Border.all(
                  color: (hasError && widget.showErrorText) ? Colors.red : Colors.black.withValues(alpha: 0.1), // Visible border
                  width: 1.5,
                ),
              ),
              child: m.TextField(
                controller: _controller,
                obscureText: widget.isPassword ? _obscureText : false,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                onChanged: _validate,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.black.withValues(alpha: 0.3), // Darker hint for better visibility
                    fontSize: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                  suffixIcon: widget.isPassword
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black87,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (hasError && widget.showErrorText) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: m.Text(
                _errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
