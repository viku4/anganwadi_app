import 'package:anganwadi_connect/core/theme/app_colors.dart';
import 'package:anganwadi_connect/core/theme/theme_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String hintText;
  final IconData? prefixIcon;
  final void Function(T?)? onChanged;
  final String Function(T) itemAsString;
  final String? Function(T?)? validator;
  final PopupType? popupType;
  final bool? showSearchBox;
  final AutovalidateMode? autoValidateMode;

  final bool? filled;
  final Color? fillColor;
  final InputBorder? outlineInputBorder;
  final TextStyle? hintStyle;
  final Color? iconColor;
  const CustomDropdownSearch({
    super.key,
    required this.items,
    required this.hintText,
    this.prefixIcon,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.validator,
    this.popupType,
    this.showSearchBox,
    this.filled,
    this.fillColor,
    this.outlineInputBorder,
    this.hintStyle,
    this.iconColor,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDark = themeProvider.isDark;
    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    return DropdownSearch<T>(
      items: (filter, loadProps) => items,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      compareFn: (item1, item2) => item1 == item2,
      validator: validator,
      onSelected: onChanged,
      autoValidateMode: autoValidateMode,
      textProps: TextProps(style: hintStyle ?? TextStyle()),
      popupProps: _getPopupProps(
        popupType: popupType,
        showSearchBox: showSearchBox ?? true,
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: AppColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          hintText: hintText,
          filled: filled ?? true,
          fillColor: fillColor,
          suffixIconColor: iconColor,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: iconColor)
              : null,
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),

          // ==========================================================
          // DISABLED BORDER
          // ==========================================================
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: borderColor.withOpacity(0.5),
              width: 1,
            ),
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

          hintStyle: hintStyle ?? TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  PopupProps<T> _getPopupProps({
    required PopupType? popupType,
    required bool showSearchBox,
  }) {
    switch (popupType) {
      case PopupType.menu:
        return PopupProps.menu(
          showSearchBox: showSearchBox,
          menuProps: MenuProps(
            barrierDismissible: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // borderRadius: BorderRadius.circular(20),
            elevation: 8,
          ),
        );

      case PopupType.dialog:
        return PopupProps.dialog(
          showSearchBox: showSearchBox,
          fit: FlexFit.loose,
          dialogProps: DialogProps(
            barrierLabel: 'Dismiss',
            barrierDismissible: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
          ),
        );

      case PopupType.bottomSheet:
        return PopupProps.bottomSheet(
          showSearchBox: showSearchBox,
          bottomSheetProps: BottomSheetProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            elevation: 8,
          ),
        );

      case PopupType.modalBottomSheet:
        return PopupProps.modalBottomSheet(
          showSearchBox: showSearchBox,
          modalBottomSheetProps: ModalBottomSheetProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            elevation: 8,
          ),
        );

      default:
        return PopupProps.modalBottomSheet(
          showSearchBox: showSearchBox,
          modalBottomSheetProps: ModalBottomSheetProps(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            elevation: 8,
          ),
        );
    }
  }
}

enum PopupType { menu, dialog, bottomSheet, modalBottomSheet }
