import 'package:flutter/material.dart';

class PostCardFooterActionStyleButtonWidget extends StatelessWidget {
  const PostCardFooterActionStyleButtonWidget({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
              width: 0.6,
              color: Theme.of(context).colorScheme.primaryContainer),
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: child,
    );
  }
}
