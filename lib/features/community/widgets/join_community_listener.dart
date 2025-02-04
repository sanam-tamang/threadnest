// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';

import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';

class JoinCommunityListener extends StatelessWidget {
  const JoinCommunityListener({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinCommunityBloc, JoinCommunityState>(
      listener: (context, state) async {
        if (state is JoinCommunityLoading) {
          await AppProgressIndicator.show2(context);
        } else if (state is JoinCommunityLoaded) {
          sl<GetCommunityBloc>().add(const GetCommunityEvent());
          sl<GetJoinedCommunityBloc>().add(const GetJoinedCommunityEvent());
          context.pop();
          AppToast.show("Joined success");
        } else if (state is JoinCommunityFailure) {
          context.pop();
          AppToast.show(state.failure.message.contains('duplicate')
              ? "Already joined in community"
              : "Something went wrong");
        }
      },
      child: child,
    );
  }
}
