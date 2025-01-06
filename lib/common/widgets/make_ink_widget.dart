import 'package:flutter/material.dart';

class MakeInkButton extends StatelessWidget {
  const MakeInkButton({
    super.key,
    required this.onTap,
    required this.child,
  });
  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
            // color: Theme.of(context).colorScheme.surfaceContainer,
            ),
        child: InkWell(
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.grey,
            onTap: onTap,
            child: child),
      ),
    );
  }
}
