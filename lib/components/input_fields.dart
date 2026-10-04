import 'dart:developer';

import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/core/theme/app_colors.dart';
import 'package:anganwadi_connect/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TextFieldData extends StatefulWidget {
  final int? minLines;
  final bool? enabled;
  final int? maxLines;

  final Color? cursorColor;
  final TextStyle? style;

  final bool? obscureText;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final InputDecoration? decoration;

  final bool? readOnly;
  final String? hintText;

  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  final TextInputType? keyboardType;

  final TextEditingController? controller;

  final String? label;
  final Color? labelColor;

  final String? text;

  final bool? filled;
  final Color? fillColor;

  final InputBorder? outlineInputBorder;

  final TextStyle? hintStyle;

  final Color? iconColor;

  final String? counterText;

  const TextFieldData({
    super.key,
    this.minLines,
    this.enabled,
    this.maxLines,
    this.cursorColor,
    this.style,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.decoration,
    this.readOnly,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode,
    this.keyboardType,
    this.controller,
    this.label,
    this.text,
    this.validator,
    this.labelColor,
    this.filled,
    this.fillColor,
    this.outlineInputBorder,
    this.hintStyle,
    this.iconColor,
    this.counterText,
  });

  @override
  State<TextFieldData> createState() => _TextFieldDataState();
}

class _TextFieldDataState extends State<TextFieldData> {
  @override
  Widget build(BuildContext context) {
    final bool isObscured = widget.obscureText ?? false;

    final int adjustedMaxLines = isObscured ? 1 : (widget.maxLines ?? 5);

    // ==========================================================
    // THEME
    // ==========================================================

    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDark = themeProvider.isDark;

    // ==========================================================
    // THEME COLORS
    // ==========================================================

    final Color textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;

    final Color backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    final Color surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    return TextFormField(
      // ==========================================================
      // BASIC
      // ==========================================================
      controller: widget.controller,

      enabled: widget.enabled,

      readOnly: widget.readOnly ?? false,

      obscureText: isObscured,

      keyboardType: widget.keyboardType,

      minLines: widget.minLines ?? 1,

      maxLines: adjustedMaxLines,

      // ==========================================================
      // TEXT STYLE
      // ==========================================================
      style:
          widget.style ??
          TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),

      // ==========================================================
      // CURSOR
      // ==========================================================
      cursorColor: widget.cursorColor ?? AppColors.primary,

      cursorWidth: 2,

      cursorHeight: 20,

      // ==========================================================
      // EVENTS
      // ==========================================================
      onChanged: widget.onChanged,

      onTap: widget.onTap,

      onTapOutside: (event) {
        final context = RoutingService.navigatorKey.currentContext;

        if (context == null) {
          log("Context is null!");
        } else {
          log("Context is valid");
        }

        FocusManager.instance.primaryFocus?.unfocus();
      },

      // ==========================================================
      // VALIDATION
      // ==========================================================
      validator: widget.validator,

      autovalidateMode: widget.autovalidateMode,

      // ==========================================================
      // FORMATTERS
      // ==========================================================
      inputFormatters: widget.inputFormatters,

      // ==========================================================
      // DECORATION
      // ==========================================================
      decoration:
          widget.decoration ??
          _buildDecoration(
            textColor: textColor,
            subTextColor: subTextColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            surfaceColor: surfaceColor,
            isDark: isDark,
          ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _buildDecoration({
    required Color textColor,
    required Color subTextColor,
    required Color backgroundColor,
    required Color borderColor,
    required Color surfaceColor,
    required bool isDark,
  }) {
    return InputDecoration(
      // ==========================================================
      // TEXT
      // ==========================================================
      hintText: widget.hintText,

      labelText: widget.label,

      counterText: widget.counterText,

      // ==========================================================
      // HINT STYLE
      // ==========================================================
      hintStyle:
          widget.hintStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: subTextColor,
          ),

      // ==========================================================
      // LABEL STYLE
      // ==========================================================
      labelStyle:
          widget.hintStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: widget.labelColor ?? subTextColor,
          ),

      // ==========================================================
      // FLOATING LABEL
      // ==========================================================
      floatingLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: widget.labelColor ?? AppColors.primary,
      ),

      // ==========================================================
      // ICONS
      // ==========================================================
      prefixIcon: widget.prefixIcon,

      suffixIcon: widget.suffixIcon,

      // ==========================================================
      // BACKGROUND
      // ==========================================================
      filled: widget.filled ?? true,

      fillColor:
          widget.fillColor ??
          (isDark ? AppColors.darkSurface : AppColors.lightSurface),

      // ==========================================================
      // CONTENT PADDING
      // ==========================================================
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      // ==========================================================
      // DEFAULT BORDER
      // ==========================================================
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),

      // ==========================================================
      // ENABLED BORDER
      // ==========================================================
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),

      // ==========================================================
      // FOCUSED BORDER
      // ==========================================================
      focusedBorder:
          widget.outlineInputBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),

      // ==========================================================
      // DISABLED BORDER
      // ==========================================================
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
      ),

      // ==========================================================
      // ERROR BORDER
      // ==========================================================
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),

      // ==========================================================
      // FOCUSED ERROR BORDER
      // ==========================================================
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),

      // ==========================================================
      // ERROR STYLE
      // ==========================================================
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ================================================================
// UPPER CASE FORMATTER
// ================================================================

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
