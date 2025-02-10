import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:threadnest/dependency_injection.dart' as di;
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/features/chat/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:threadnest/features/chat/blocs/create_chat_room_bloc/create_chat_room_bloc.dart';
import 'package:threadnest/features/chat/blocs/message_bloc/message_bloc.dart';
import 'package:threadnest/features/chat/blocs/send_message_bloc/send_message_bloc.dart';
import 'package:threadnest/features/comment/blocs/post_comment_bloc/post_comment_bloc.dart';
import 'package:threadnest/features/comment/blocs/vote_comment_bloc/vote_comment_bloc.dart';
import 'package:threadnest/features/community/blocs/create_community_bloc/create_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/blocs/leave_community_bloc/leave_community_bloc.dart';
import 'package:threadnest/features/community_admin/blocs/remove_community_bloc/remove_community_post_bloc.dart';
import 'package:threadnest/features/post/blocs/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/blocs/post_feed_bloc/post_feed_bloc.dart';
import 'package:threadnest/features/post/blocs/post_vote_bloc/post_vote_bloc.dart';
import 'package:threadnest/features/profile/blocs/edit_user_bloc/edit_user_bloc.dart';
import 'package:threadnest/features/profile/blocs/user_bloc/user_bloc.dart';
import 'package:threadnest/firebase_options.dart';
import 'package:threadnest/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // await ScreenUtil.ensureScreenSize();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  di.init();
  // await preloadSVGs(['assets/svgs/google_logo.svg']);

  await Supabase.initialize(
    url: 'https://zzpafhzqyklbkmcogjvs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp6cGFmaHpxeWtsYmttY29nanZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1MzM3NzgsImV4cCI6MjA0MzEwOTc3OH0.qRb-hsS31tlwZn_lwgMUMwctrFF3s8fKUIGrFP7h7zw',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  FlutterNativeSplash.remove();
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
          BlocProvider(create: (context) => di.sl<AuthBloc>()),
          BlocProvider(create: (context) => di.sl<PostFeedBloc>()),
          BlocProvider(
              create: (context) =>
                  di.sl<GetPostsBloc>()..add(const GetPostsEvent())),
          BlocProvider(create: (context) => di.sl<CreateCommunityBloc>()),
          BlocProvider(
            create: (context) =>
                di.sl<GetCommunityBloc>()..add(const GetCommunityEvent()),
          ),
          BlocProvider(create: (context) => di.sl<JoinCommunityBloc>()),
          BlocProvider(create: (context) => di.sl<PostVoteBloc>()),
          BlocProvider(create: (context) => di.sl<GetPostByIdBloc>()),
          BlocProvider(create: (context) => di.sl<PostCommentBloc>()),
          BlocProvider(create: (context) => di.sl<VoteCommentBloc>()),
          BlocProvider(create: (context) => di.sl<RemoveCommunityPostBloc>()),
          BlocProvider(create: (context) => di.sl<CreateChatRoomBloc>()),
          BlocProvider(create: (context) => di.sl<UserBloc>()),
          BlocProvider(create: (context) => di.sl<EditUserBloc>()),
          BlocProvider(create: (context) => di.sl<SendMessageBloc>()),
          BlocProvider(create: (context) => di.sl<MessageBloc>()),
          BlocProvider(create: (context) => di.sl<LeaveCommunityBloc>()),
          BlocProvider(
              create: (context) =>
                  di.sl<ChatRoomBloc>()..add(const GetChatRoomEvent())),
          BlocProvider(
            create: (context) => di.sl<GetJoinedCommunityBloc>()
              ..add(const GetJoinedCommunityEvent()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Threadnest',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: ColorsManager.mainBlue),
              textTheme:
                  GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
          routerConfig: AppRoute.router,
        ));
  }
}
