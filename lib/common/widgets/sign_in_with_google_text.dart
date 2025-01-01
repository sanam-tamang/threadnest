import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:threadnest/common/utils/build_divider.dart';

class SigninWithGoogleText extends StatelessWidget {
  const SigninWithGoogleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        BuildDivider.buildDivider(),
        const Gap(5),
        Text(
          'or Sign in with',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Gap(5),
        BuildDivider.buildDivider(),
      ],
    );
  }
}
