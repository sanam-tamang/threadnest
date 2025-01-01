import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:threadnest/common/utils/app_regex.dart';
import 'package:threadnest/common/widgets/app_text_button.dart';
import 'package:threadnest/common/widgets/app_text_form_field.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          emailField(),
          const Gap(30),
          resetButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  AppTextFormField emailField() {
    return AppTextFormField(
      hint: 'Email',
      validator: (value) {
        String email = (value ?? '').trim();

        emailController.text = email;

        if (email.isEmpty) {
          return 'Please enter an email address';
        }

        if (!AppRegex.isEmailValid(email)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      controller: emailController,
    );
  }

  AppTextButton resetButton() {
    return AppTextButton(
      buttonText: 'Reset',
      textStyle: Theme.of(context).textTheme.labelLarge!,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // context.read<AuthCubit>().resetPassword(emailController.text);
        }
      },
    );
  }
}
