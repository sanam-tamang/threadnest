import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/logo.dart';
import 'package:threadnest/common/utils/app_dialog.dart';
import 'package:threadnest/common/utils/validator.dart';
import 'package:threadnest/features/auth/widgets/already_have_account_text.dart';
import 'package:threadnest/common/widgets/app_text_form_field.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/common/widgets/sign_in_with_google_text.dart';
import 'package:threadnest/common/widgets/terms_and_conditions_text.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(24),
                const Center(
                  child: AppLogo(),
                ),
                const Gap(24),
                Center(
                  child: Text(
                    "Join us today!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const Gap(8),
                Center(
                  child: Text(
                    "Create your account and unlock unlimited access to data, insights, and more",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Gap(48),
                AppTextFormField(
                  hint: "Name",
                  controller: _nameController,
                  validator: (value) => value!.isEmpty
                      ? "Name can't be empty"
                      : value.length > 20
                          ? "Name can't be greater then twently letters"
                          : null,
                ),
                const Gap(18),
                AppTextFormField(
                    hint: "Email",
                    controller: _emailController,
                    validator: Validator.validateEmail),
                const Gap(18),
                AppTextFormField(
                    hint: "Password",
                    controller: _passwordController,
                    isObscureText: true,
                    validator: Validator.validatePassword),
                const Gap(18),
                AppTextFormField(
                  hint: "Confirm Password",
                  controller: _confirmPasswordController,
                  isObscureText: true,
                  validator: (value) => value == _passwordController.text
                      ? null
                      : "Confirm password do not match",
                ),
                const Gap(20),
                BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthLoading) {
                        await AppProgressIndicator.show(context);
                      } else if (state is AuthError) {
                        await AppDialog.error(context, state.failure.message);
                        if (context.mounted) {
                          context.pop();
                        }
                      } else if (state is AuthSignedIn) {
                        context.pop();
                        context.goNamed(AppRouteName.navbar);
                      } else if (state is AuthSignedInNotVerified) {
                        context.pop();
                        await AppDialog.success(context,
                            "Verification email has been sent to your email address",
                            autoCloseAfterMiliSeconds: 2500);

                        if (context.mounted) {
                          context.goNamed(AppRouteName.navbar);
                        }
                      } else {
                        // context.pop();

                        log("Else case at sign up");
                      }
                    },
                    child: SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: _onSignUp,
                        child: const Text(
                          "Sign up",
                        ),
                      ),
                    )),
                const Gap(20),
                Column(
                  children: [
                    const Gap(10),
                    const SigninWithGoogleText(),
                    const Gap(15),
                    InkWell(
                      onTap: () => sl<AuthBloc>().add(SignInWithGoogleEvent()),
                      child: SvgPicture.asset(
                        'assets/svgs/google_logo.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const Gap(15),
                    const TermsAndConditionsText(),
                    const Gap(15),
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      sl<AuthBloc>().add(SignUpWithEmailAndPasswordEvent(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text));
    }
  }
}
