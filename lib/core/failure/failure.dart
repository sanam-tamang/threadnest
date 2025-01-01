import 'package:equatable/equatable.dart';

 class Failure extends Equatable {
  final String message;
  const Failure({required this.message});


@override
  String toString() {
 
    return message.toString();
  }
  @override
  List<Object?> get props => [];
}
