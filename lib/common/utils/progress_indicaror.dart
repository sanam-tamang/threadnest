import 'package:flutter/material.dart';
import 'package:threadnest/core/theme/colors.dart';

class AppProgressIndicator {
  ///This is loading is mainly focused on auth
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.mainBlue,
          ),
        );
      },
    );
  }

  ///This loading shows the loading with container on it
  static Future<void> show2(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1,
                      offset: Offset(1, 1))
                ],
                borderRadius: BorderRadius.circular(15)),
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.mainBlue,
              ),
            ),
          ),
        );
      },
    );
  }
}
