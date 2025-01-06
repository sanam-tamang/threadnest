import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/common/extension.dart';

import 'package:threadnest/features/auth/pages/forget_page.dart';
import 'package:threadnest/features/auth/pages/login.dart';
import 'package:threadnest/features/auth/pages/sign_up.dart';
import 'package:threadnest/features/chat/pages/message_page.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/pages/community_detail_page.dart';
import 'package:threadnest/features/community/pages/create_community_page.dart';

import 'package:threadnest/features/home/pages/home.dart';
import 'package:threadnest/features/navigation_bar/pages/navigation_bar.dart';
import 'package:threadnest/features/onboarding/onboarding_page.dart';
import 'package:threadnest/features/post/pages/post_posting_page.dart';
import 'package:threadnest/features/post/pages/post_detail_page.dart';
import 'package:threadnest/features/profile/pages/user_profile.dart';
import 'package:threadnest/features/profile/models/user.dart' as local;

class AppRouteName {
  static const String home = 'home';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'sign-up';
  static const String dashboard = 'dashboard';
  static const String navbar = 'navbar';
  static const String questionDetail = 'question-detail';
  static const String questionAskingPage = 'ask-question';
  static const String forget = 'forget-password';
  static const String createCommunity = 'create-community';
  static const String communityPage = 'community';
  static const String userProfilePage = 'user-profile';
  static const String message = 'message';
}

class AppRoute {
  static GoRouter get router => GoRouter(
        initialLocation: AppRouteName.login.path(),

        // redirect: (BuildContext context, GoRouterState state) {

        // },

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
            redirect: (context, state) =>
                redirectWhenUserComeIntoSignupOrSignInPage(
                    context, state, true),
            builder: (context, state) => const SignInPage(),
          ),
          GoRoute(
            name: AppRouteName.signup,
            path: AppRouteName.signup.path(),
            redirect: (context, state) =>
                redirectWhenUserComeIntoSignupOrSignInPage(
                    context, state, false),
            builder: (context, state) => const SignUpPage(),
          ),
          GoRoute(
            name: AppRouteName.questionDetail,
            path: "${AppRouteName.questionDetail.path()}/:postId",
            builder: (context, state) {
              final postKey = state.uri.queryParameters['postKey'];
              final postId = state.pathParameters['postId'];
              return PostDetailPage(postId: postId!, postKey: postKey!);
            },
          ),
          GoRoute(
            name: AppRouteName.questionAskingPage,
            path: AppRouteName.questionAskingPage.path(),
            builder: (context, state) {
              final Community? community = state.extra as Community?;
              return PostPostingPage(community: community);
            },
          ),
          GoRoute(
            name: AppRouteName.forget,
            path: AppRouteName.forget.path(),
            builder: (context, state) => const ForgetPage(),
          ),
          GoRoute(
            name: AppRouteName.userProfilePage,
            path: "${AppRouteName.userProfilePage.path()}/:id",
            builder: (context, state) {
              final currentlyVisitedUserProfileId = state.pathParameters['id'];
              return UserProfilePage(
                currentVisitedUserProfileId: currentlyVisitedUserProfileId,
              );
            },
          ),
          GoRoute(
            name: AppRouteName.message,
            path: "${AppRouteName.message.path()}/:chatRoomId",
            builder: (context, state) {
              final chatRoomId = state.pathParameters['chatRoomId'];
              final user = state.extra as local.User;
              return MessagePage(
                chatRoomId: chatRoomId!,
                chatPartner: user,
              );
            },
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

  static FutureOr<String?> redirectWhenUserComeIntoSignupOrSignInPage(
      BuildContext context, GoRouterState state, bool isLoginPage) async {
    if (state.uri.path.contains(AppRouteName.signup.path()) ||
        state.uri.path.contains(AppRouteName.login.path())) {
      return FirebaseAuth.instance.currentUser == null
          ? isLoginPage
              ? AppRouteName.login.path()
              : AppRouteName.signup.path()
          : AppRouteName.navbar.rootPath();
    }

    return null;
  }
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
