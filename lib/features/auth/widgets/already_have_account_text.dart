import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/router.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRouteName.login);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(
              text: ' Login',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
