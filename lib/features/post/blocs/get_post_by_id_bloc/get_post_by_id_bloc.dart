import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/post/models/post_model.dart';
import 'package:threadnest/features/post/repositories/post_repositories.dart';

part 'get_post_by_id_event.dart';
part 'get_post_by_id_state.dart';

class GetPostByIdBloc extends Bloc<BaseGetPostByIdEvent, GetPostByIdState> {
  final PostRepositories _repo;

  GetPostByIdBloc({required PostRepositories repo})
      : _repo = repo,
        super(GetPostByIdInitial()) {
    on<GetPostByIdEvent>(_onGetPost);
    on<UpdatePostByIdEvent>(_onUpdatePostByIdEvent);
  }

  Future<void> _onGetPost(
      GetPostByIdEvent event, Emitter<GetPostByIdState> emit) async {
    emit(GetPostByIdLoading());
    try {
      final GetPost post =
          await _repo.getPostFromIdWithComments(postId: event.postId);

      emit(GetPostByIdLoaded(post: post));
    } catch (e) {
      emit(GetPostByIdFailure(failure: Failure(message: e.toString())));
    }
  }

  ///it will update post indivisually 
 void _onUpdatePostByIdEvent(
      UpdatePostByIdEvent event, Emitter<GetPostByIdState> emit)  {

      emit(GetPostByIdLoaded(post: event.post));
   
  }
}
