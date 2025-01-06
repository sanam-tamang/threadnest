import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.dimension,
    this.fit,
  });
  final double? dimension;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: Size.square(dimension ?? 160),
        child: Image.asset(
          'assets/images/logo_bg_removed.png',
          fit: fit ?? BoxFit.cover,
        ));
  }
}
