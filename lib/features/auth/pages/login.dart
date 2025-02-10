import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/logo.dart';
import 'package:threadnest/common/utils/app_dialog.dart';
import 'package:threadnest/common/utils/validator.dart';
import 'package:threadnest/common/widgets/app_text_form_field.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/common/widgets/sign_in_with_google_text.dart';
import 'package:threadnest/common/widgets/terms_and_conditions_text.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/features/auth/widgets/do_not_have_account.dart';
import 'package:threadnest/router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Gap(24),
              const Center(child: AppLogo()),
              const Gap(24),
              Center(
                child: Text(
                  "Welcome Back!",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(8),
              Center(
                child: Text(
                  "Enter to get unlimited access to data & information",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Gap(48),
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
              const Gap(4),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () => context.pushNamed(AppRouteName.forget),
                    splashColor: Theme.of(context).colorScheme.surface,
                    child: Text(
                      "Forget password",
                      style: Theme.of(context).textTheme.labelMedium,
                    )),
              ),
              const Gap(20),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthLoading) {
                    await AppProgressIndicator.show(context);
                  } else if (state is AuthError) {
                    await AppDialog.error(context, state.failure.toString());
                    if (context.mounted) {
                      context.pop();
                    }
                  } else if (state is AuthSignedIn) {
                    context.pop();
                    context.goNamed(AppRouteName.navbar);
                  } else {
                    // context.pop();

                    log("Else case at sign in");
                  }
                },
                child: SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                        onPressed: _onLogin,
                        child: const Text(
                          "Login",
                        ))),
              ),
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
                  const DoNotHaveAccountText(),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      sl<AuthBloc>().add(SignInWithEmailAndPasswordEvent(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
