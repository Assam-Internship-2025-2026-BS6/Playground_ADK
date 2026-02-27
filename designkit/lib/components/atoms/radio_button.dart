import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final Color activeColor;
  final Color labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double size;
  final Offset offset;

  const RadioButton({
    super.key,
    required this.value,
    this.onChanged,
    this.label = "Radio Option",
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = Colors.black87,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.normal,
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value;
    
    return Transform.translate(
      offset: offset,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!value);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Transform.scale(
              scale: size,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? activeColor : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isSelected
                          ? Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: activeColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: labelColor,
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