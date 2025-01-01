import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/router.dart';

class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRouteName.signup);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account yet?',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(
              text: ' Sign Up',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
