import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/core/repositories/file_uploader.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';

part 'create_community_event.dart';
part 'create_community_state.dart';

class CreateCommunityBloc
    extends Bloc<CreateCommunityEvent, CreateCommunityState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final BaseFileUploader _imageUploader;
  final CommunityRepository _repo;

  CreateCommunityBloc(
      {required BaseFileUploader fileUploader,
      required CommunityRepository repo})
      : _imageUploader = fileUploader,
        _repo = repo,
        super(CreateCommunityInitial()) {
    on<CreateCommunityEvent>(_onCreateCommunity);
  }

  Future<void> _onCreateCommunity(
      CreateCommunityEvent event, Emitter<CreateCommunityState> emit) async {
    emit(CreateCommunityLoading());

    try {
      final imageUrl = await _imageUploader.imageUploader(event.imageFile);

      final userId = _auth.currentUser?.uid;

      await _repo.createCommunity(
        name: event.name,
        description: event.description,
        ownerId: userId!,
        imageUrl: imageUrl,
      );

      emit(CreateCommunityLoaded());
    } catch (e) {
      emit(CreateCommunityFailure(failure: Failure(message: e.toString())));
    }
  }
}
