import 'package:get_it/get_it.dart';
import 'package:threadnest/core/repositories/file_uploader.dart';
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/features/chat/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:threadnest/features/chat/blocs/create_chat_room_bloc/create_chat_room_bloc.dart';
import 'package:threadnest/features/chat/blocs/message_bloc/message_bloc.dart';
import 'package:threadnest/features/chat/blocs/send_message_bloc/send_message_bloc.dart';
import 'package:threadnest/features/chat/repositories/chat_room_repository.dart';
import 'package:threadnest/features/chat/repositories/message_repository.dart';
import 'package:threadnest/features/comment/blocs/post_comment_bloc/post_comment_bloc.dart';
import 'package:threadnest/features/comment/blocs/vote_comment_bloc/vote_comment_bloc.dart';
import 'package:threadnest/features/comment/repositories/comment_repository.dart';
import 'package:threadnest/features/comment/repositories/vote_comment_repository.dart';
import 'package:threadnest/features/community/blocs/create_community_bloc/create_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/blocs/leave_community_bloc/leave_community_bloc.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';
import 'package:threadnest/features/community_admin/blocs/remove_community_bloc/remove_community_post_bloc.dart';
import 'package:threadnest/features/community_admin/repositories/community_admin_repositories.dart';
import 'package:threadnest/features/post/blocs/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/blocs/post_feed_bloc/post_feed_bloc.dart';
import 'package:threadnest/features/post/blocs/post_vote_bloc/post_vote_bloc.dart';
import 'package:threadnest/features/post/repositories/post_repositories.dart';
import 'package:threadnest/features/post/repositories/post_vote_repository.dart';
import 'package:threadnest/features/profile/blocs/edit_user_bloc/edit_user_bloc.dart';
import 'package:threadnest/features/profile/blocs/user_bloc/user_bloc.dart';
import 'package:threadnest/features/profile/repositories/user_repository.dart';

final GetIt sl = GetIt.instance;

void init() {
  ///bloc
  sl.registerLazySingleton(() => AuthBloc());
  sl.registerLazySingleton(() => PostFeedBloc(repo: sl()));
  sl.registerLazySingleton(() => GetPostsBloc(repo: sl()));
  sl.registerLazySingleton(
      () => CreateCommunityBloc(fileUploader: sl(), repo: sl()));
  sl.registerLazySingleton(() => GetCommunityBloc(repo: sl()));
  sl.registerLazySingleton(() => GetJoinedCommunityBloc(repo: sl()));
  sl.registerLazySingleton(() => PostVoteBloc(bloc: sl(), repo: sl()));
  sl.registerFactory(() => JoinCommunityBloc(repo: sl()));
  sl.registerLazySingleton(() => RemoveCommunityPostBloc(repo: sl()));
  sl.registerLazySingleton(() => GetPostByIdBloc(repo: sl()));
  sl.registerLazySingleton(() => PostCommentBloc(repo: sl()));
  sl.registerLazySingleton(() => VoteCommentBloc(repo: sl()));
  sl.registerLazySingleton(() => UserBloc(repo: sl()));
  sl.registerLazySingleton(() => CreateChatRoomBloc(repo: sl()));
  sl.registerLazySingleton(() => SendMessageBloc(repo: sl()));
  sl.registerLazySingleton(() => MessageBloc(repo: sl()));
  sl.registerLazySingleton(() => ChatRoomBloc(repo: sl()));
  sl.registerLazySingleton(() => EditUserBloc(repo: sl()));
  sl.registerLazySingleton(() => LeaveCommunityBloc(repo: sl()));

  ///repositories
  sl.registerLazySingleton(() => PostVoteRepository());
  sl.registerLazySingleton(() => MessageRepository());
  sl.registerLazySingleton(() => PostRepositories());
  sl.registerLazySingleton(() => CommunityRepository());
  sl.registerLazySingleton(() => CommunityAdminRepositories());
  sl.registerLazySingleton(() => CommentRepository());
  sl.registerLazySingleton(() => VoteCommentRepository());
  sl.registerLazySingleton(() => UserRepository(fileUploader: sl()));
  sl.registerLazySingleton(() => ChatRoomRepository());
  sl.registerLazySingleton<BaseFileUploader>(() => FileUploader());
}
