import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool disabled;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color disabledBg = Colors.grey.shade300;
  final Color disabledFg = Colors.grey.shade600;

  AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.disabled = false,
    this.icon,
    this.foregroundColor = const Color(0xFF1B5E20), // Dark green text/icon
    this.backgroundColor = const Color(0xFFE8F5E9), // Very light green
  });

  @override
  Widget build(BuildContext context) {
    final action = disabled ? null : onPressed;
    final isEnabled = action != null;

    return ElevatedButton.icon(
      label: Text(label),
      icon:
          icon != null
              ? Icon(icon, color: isEnabled ? foregroundColor : disabledFg)
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? backgroundColor : disabledBg,
        foregroundColor: isEnabled ? foregroundColor : disabledFg,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isEnabled ? 2 : 0,
      ),
      onPressed: action,
    );
  }
}
