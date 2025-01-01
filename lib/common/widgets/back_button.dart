// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.iconColor,
    this.onPressed,
  });
  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => onPressed??_onPressedBack(context),
        icon: Icon(
          Icons.arrow_back_ios,
          color: iconColor,
        ));
  }

  void _onPressedBack(BuildContext context) {
    context.canPop() ? context.pop() : () {};
  }
}
