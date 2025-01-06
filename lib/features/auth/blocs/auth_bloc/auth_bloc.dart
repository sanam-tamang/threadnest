import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/core/failure/failure.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<SignUpWithEmailAndPasswordEvent>(_onSignUp);
    on<SignInWithEmailAndPasswordEvent>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSignUp(
    SignUpWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    log("hello world ");
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final userId = _firebaseAuth.currentUser!.uid;
      await _firebaseAuth.currentUser?.sendEmailVerification();

      await _createUserOnSupabaseTable(userId, event);

      emit(AuthSignedInNotVerified());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(Failure(message: e.message ?? "Sign-up failed")));
    } catch (e) {
      emit(AuthError(Failure(message: e.toString())));
    }
  }

  Future<void> _onSignInWithEmailAndPassword(
    SignInWithEmailAndPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(Failure(message: e.message ?? "Sign-in failed")));
    } catch (e) {
      emit(AuthError(Failure(message: e.toString())));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Add your Google sign-in logic here (e.g., using GoogleSignIn plugin)
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(Failure(message: e.message ?? "Google sign-in failed")));
    } catch (e) {
      emit(AuthError(Failure(message: e.toString())));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordResetSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(Failure(message: e.message ?? "Reset password failed")));
    } catch (e) {
      emit(AuthError(Failure(message: e.toString())));
    }
  }

  Future<void> _createUserOnSupabaseTable(
      String userId, SignUpWithEmailAndPasswordEvent event) async {
    await Supabase.instance.client.from('users').insert({
      'id': userId,
      // 'imageUrl': imagePath,
      'name': event.name,
      'email': event.email
    });
  }
}
