import 'package:flutter/material.dart';
import 'package:threadnest/core/theme/colors.dart';



class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By logging, you agree to our',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorsManager.gray),
          ),
          TextSpan(
            text: ' Terms & Conditions',
            style:  Theme.of(context).textTheme.labelSmall,
          ),
          TextSpan(
            text: ' and',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorsManager.gray)
              
          ),
          TextSpan(
            text: ' PrivacyPolicy.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
