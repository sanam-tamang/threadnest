import 'package:flutter/material.dart';
import 'package:threadnest/core/failure/failure.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.failure});
  final Failure failure;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(failure.message));
  }
}
