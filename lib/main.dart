import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/common/extension.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:threadnest/dependency_injection.dart' as di;
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/features/community/blocs/create_community_bloc/create_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/question/blocs/get_question_bloc/get_question_bloc.dart';
import 'package:threadnest/features/question/blocs/post_question_bloc/post_question_bloc.dart';
import 'package:threadnest/features/question/blocs/question_vote_bloc/question_vote_bloc.dart';
import 'package:threadnest/firebase_options.dart';
import 'package:threadnest/router.dart';

late String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ScreenUtil.ensureScreenSize();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await preloadSVGs(['assets/svgs/google_logo.svg']);

  await Supabase.initialize(
    url: 'https://zzpafhzqyklbkmcogjvs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6cGFmaHpxeWtsYmttY29nanZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1MzM3NzgsImV4cCI6MjA0MzEwOTc3OH0.qRb-hsS31tlwZn_lwgMUMwctrFF3s8fKUIGrFP7h7zw',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen(
    (user) {
      if (user == null) {
        initialRoute = AppRouteName.login.path();
      } else {
        initialRoute = AppRouteName.navbar.rootPath();
      }
    },
  );
  // initialRoute = AppRouteName.navbar.rootPath();

  await di.init();
  runApp(const MyApp());
}

Future<void> preloadSVGs(List<String> paths) async {
  for (final path in paths) {
    final loader = SvgAssetLoader(path);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => di.sl<PostQuestionBloc>(),
          ),
          BlocProvider(create: (context) => di.sl<GetQuestionBloc>()),
          BlocProvider(
            create: (context) => di.sl<CreateCommunityBloc>(),
          ),
          BlocProvider(
            create: (context) =>
                di.sl<GetCommunityBloc>()..add(const GetCommunityEvent()),
          ),
          BlocProvider(create: (context) => di.sl<JoinCommunityBloc>()),
          BlocProvider(create: (context) => di.sl<QuestionVoteBloc>()),
          BlocProvider(
            create: (context) => di.sl<GetJoinedCommunityBloc>()
              ..add(const GetJoinedCommunityEvent()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Threadnest',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: ColorsManager.mainBlue),
              textTheme:
                  GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
          routerConfig: AppRoute.router(initialRoute),
        ));
  }
}
