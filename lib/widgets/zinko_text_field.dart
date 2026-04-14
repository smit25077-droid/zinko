import 'package:flutter/material.dart';
import '../core/theme/optimized_colors.dart';
import '../utils/glass_theme.dart';

class ZinkoTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool readOnly;
  final bool isRequired;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final bool isPascalCase;

  const ZinkoTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.hintText,
    this.readOnly = false,
    this.isRequired = true,
    this.onTap,
    this.validator,
    this.isPascalCase = false,
  });

  String _toPascalCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly || onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
          onChanged: isPascalCase ? (value) {
            final pascal = _toPascalCase(value);
            if (pascal != value) {
              controller.value = controller.value.copyWith(
                text: pascal,
                selection: TextSelection.collapsed(offset: pascal.length),
              );
            }
          } : null,
          style: TextStyle(
              color: GlassTheme.textColor(context)
                  .withValues(alpha: readOnly ? 0.5 : 1.0),
              fontSize: 14,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly || onTap != null
                ? OptimizedColors.white12.withValues(alpha: 0.05)
                : OptimizedColors.white12,
            prefixIcon: Icon(icon,
                color: GlassTheme.iconColor(context)
                    .withValues(alpha: readOnly ? 0.2 : 0.4),
                size: 18),
            hintText: hintText ?? 'Enter $label',
            hintStyle: TextStyle(
                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.2),
                fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: GlassTheme.glassBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: GlassTheme.glassBorder(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
            ),
          ),
          validator: validator ?? (isRequired
              ? (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return null;
                }
              : null),
        ),
      ],
    );
  }
}
