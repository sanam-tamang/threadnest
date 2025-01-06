// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///means if same owner browsing his /her communities or anything has access to that widget

class OwnerAccessWidget extends StatelessWidget {
  const OwnerAccessWidget({
    super.key,
    required this.ownerId,
    required this.child,
    this.ifNotOwner,
  });
  final String ownerId;
  final Widget child;
  final Widget? ifNotOwner;


  static bool  isOwner(String ownerId) {
    return FirebaseAuth.instance.currentUser?.uid == ownerId;
  }
  @override
  Widget build(BuildContext context) {
    ///for now directly accessing firebase userid for simplycity
    ///you can make different repo or bloc for more code readability
    ///or your own logic to make like own user repo with sharepreferences
    return FirebaseAuth.instance.currentUser?.uid == ownerId
        ? child
        : ifNotOwner ?? const SizedBox.shrink();
  }
}
