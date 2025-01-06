import 'package:flutter/material.dart';

class AppBoxShadow {
  static List<BoxShadow> postBoxShadow(BuildContext context) => [
        BoxShadow(
          offset: const Offset(3, 3),
          blurRadius: 20,
          spreadRadius: -15,
          color: Theme.of(context).colorScheme.primary,
        ),
      ];
}
