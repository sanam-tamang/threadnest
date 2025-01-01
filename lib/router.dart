import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/common/extension.dart';

import 'package:threadnest/features/auth/pages/forget_page.dart';
import 'package:threadnest/features/auth/pages/login.dart';
import 'package:threadnest/features/auth/pages/sign_up.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/pages/community_detail_page.dart';
import 'package:threadnest/features/community/pages/create_community_page.dart';

import 'package:threadnest/features/home/pages/home.dart';
import 'package:threadnest/features/navigation_bar/pages/navigation_bar.dart';
import 'package:threadnest/features/onboarding/onboarding_page.dart';
import 'package:threadnest/features/question/pages/question_asking_page.dart';
import 'package:threadnest/features/question/pages/question_detail_page.dart';

class AppRouteName {
  static const String home = 'home';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String dashboard = 'dashboard';
  static const String navbar = 'navbar';
  static const String questionDetail = 'question-detail';
  static const String questionAskingPage = 'ask-question';
  static const String forget = 'forget-password';
  static const String createCommunity = 'create-community';
  static const String communityPage = 'community';
}

class AppRoute {
  static GoRouter router(String initialRoute) => GoRouter(
        initialLocation: initialRoute,

        // initialLocation: AppRouteName.signup.path(),

        // redirect: (BuildContext context, GoRouterState state) {
        //   return null;

        // return null;

        // final bool isLoggedIn = supabase.auth.currentUser != null;
        // final bool isGoingToLogin = state.name == AppRouteName.login;
        // final bool isGoingToSignup = state.name == AppRouteName.signup;

        // debugPrint('Current user: ${supabase.auth.currentUser?.email}');
        // debugPrint('Is logged in: $isLoggedIn');
        // debugPrint('Current route: ${state.name}');

        // if (!isLoggedIn) {
        //   if (!isGoingToLogin && !isGoingToSignup) {
        //     debugPrint('Redirecting to login');
        //     return AppRouteName.login.path();
        //   }
        // } else {
        //   if (isGoingToLogin || isGoingToSignup) {
        //     debugPrint('Redirecting to navbar');
        //     return AppRouteName.navbar.rootPath();
        //   }
        // }

        // debugPrint('No redirection needed');
        // return null;
        // },
        routes: <GoRoute>[
          GoRoute(
            name: AppRouteName.home,
            path: AppRouteName.home.path(),
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            name: AppRouteName.navbar,
            path: AppRouteName.navbar.rootPath(),
            builder: (context, state) => const NavigationBarPage(),
          ),
          GoRoute(
            name: AppRouteName.onboarding,
            path: AppRouteName.onboarding.path(),
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            name: AppRouteName.login,
            path: AppRouteName.login.path(),
            builder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            name: AppRouteName.signup,
            path: AppRouteName.signup.path(),
            builder: (context, state) => const SignUpPage(),
          ),
          GoRoute(
            name: AppRouteName.questionDetail,
            path: "${AppRouteName.questionDetail.path()}/:questionId",
            builder: (context, state) {
              final questionId = state.pathParameters['questionId'];
              return QuestionDetailPage(questionId: questionId!);
            },
          ),
          GoRoute(
            name: AppRouteName.questionAskingPage,
            path: AppRouteName.questionAskingPage.path(),
            builder: (context, state) {
              final Community? community = state.extra as Community?;
              return QuestionAskingPage(community: community);
            },
          ),
          GoRoute(
            name: AppRouteName.forget,
            path: AppRouteName.forget.path(),
            builder: (context, state) => const ForgetPage(),
          ),
          GoRoute(
            name: AppRouteName.createCommunity,
            path: AppRouteName.createCommunity.path(),
            builder: (context, state) {
              return const CreateCommunityPage();
            },
          ),
          GoRoute(
            name: AppRouteName.communityPage,
            path: AppRouteName.communityPage.path(),
            builder: (context, state) {
              final community = state.extra as Community;
              return CommunityDetailPage(
                community: community,
              );
            },
          ),
        ],
        errorBuilder: (context, state) => ErrorPage(error: state.error),
      );
}

class ErrorPage extends StatelessWidget {
  final Exception? error;
  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(error?.toString() ?? 'An unknown error occurred'),
      ),
    );
  }
}
