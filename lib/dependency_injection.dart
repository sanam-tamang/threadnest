import 'package:get_it/get_it.dart';
import 'package:threadnest/features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:threadnest/features/community/blocs/create_community_bloc/create_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/question/blocs/get_question_bloc/get_question_bloc.dart';
import 'package:threadnest/features/question/blocs/post_question_bloc/post_question_bloc.dart';
import 'package:threadnest/features/question/blocs/question_vote_bloc/question_vote_bloc.dart';
import 'package:threadnest/features/question/repositories/question_vote_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => AuthBloc());
  sl.registerLazySingleton(() => PostQuestionBloc());
  sl.registerLazySingleton(() => GetQuestionBloc());
  sl.registerLazySingleton(() => CreateCommunityBloc());
  sl.registerLazySingleton(() => GetCommunityBloc());
  sl.registerLazySingleton(() => GetJoinedCommunityBloc());
  sl.registerLazySingleton(() => QuestionVoteBloc(bloc: sl(), repo: sl()));

  sl.registerFactory(() => JoinCommunityBloc());
  sl.registerLazySingleton(() => QuestionVoteRepository());
}
