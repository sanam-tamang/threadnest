import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/utils/app_dialog.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';

import 'package:threadnest/features/community/widgets/community_widget.dart';
import 'package:threadnest/features/home/pages/modern_drawer.dart';
import 'package:threadnest/router.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorScheme.of(context).surfaceContainerLow,
        drawer: const DrawerPage(),
        appBar: AppBar(
          title: const Text("Communities"),
          backgroundColor: ColorScheme.of(context).surfaceContainerLowest,
        ),
        body: BlocConsumer<GetCommunityBloc, GetCommunityState>(
          listener: (context, state) {
            if (state is GetCommunityFailure) {
              AppDialog.error(context, state.failure.message);
            }
          },
          builder: (context, state) {
            if (state is GetCommunityLoading) {
              return const AppLoadingIndicator();
            } else if (state is GetCommunityLoaded) {
              return RefreshIndicator(
                  onRefresh: () async =>
                      sl<GetCommunityBloc>().add(const GetCommunityEvent()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: BuildCommunitysWidget(
                        onTap: (community) => context.pushNamed(
                            AppRouteName.communityPage,
                            extra: community),
                        communities: state.communities),
                  ));
            }
            return const SizedBox();
          },
        ));
  }
}
