import 'package:flutter/material.dart';
import 'package:threadnest/core/theme/colors.dart';

class BuildDivider {
  static Widget buildDivider() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 2,
        decoration: ShapeDecoration(
          color: ColorsManager.gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
