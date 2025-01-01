// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:threadnest/core/theme/colors.dart';

class AppTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool? isObscureText;
  final bool? isDense;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const AppTextFormField({
    super.key,
    required this.hint,
    this.suffixIcon,
    this.isObscureText,
    this.isDense,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: ColorsManager.gray),
        isDense: isDense ?? true,
        filled: true,
        fillColor: ColorsManager.lightShadeOfGray,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.gray93Color,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.mainBlue,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.coralRed,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorsManager.coralRed, width: 1.3),
          borderRadius: BorderRadius.circular(16.0),
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: isObscureText ?? false,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class AppBorderlessTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final bool? isDense;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const AppBorderlessTextFormField({
    super.key,
    required this.hint,
    this.suffixIcon,
    this.focusNode,
    this.onChanged,
    this.hintTextStyle,
    this.textStyle,
    this.isDense,
    this.maxLines = 1,
    this.controller,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintTextStyle ??
            Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ColorsManager.gray),
        isDense: isDense ?? true,
        // filled: true,
        // fillColor: ColorsManager.lightShadeOfGray,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,

        suffixIcon: suffixIcon,
      ),
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
