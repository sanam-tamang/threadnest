import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/get_community_bloc/get_community_bloc.dart';

import 'package:threadnest/features/community/widgets/community_widget.dart';
import 'package:threadnest/features/home/pages/modern_drawer.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerPage(),
        appBar: AppBar(
          title: const Text("Communities"),
        ),
        body: BlocBuilder<GetCommunityBloc, GetCommunityState>(
          builder: (context, state) {
            if (state is GetCommunityLoading) {
              return const Text("Loading");
            } else if (state is GetCommunityLoaded) {
              return RefreshIndicator(
                  onRefresh: () async =>
                      sl<GetCommunityBloc>().add(const GetCommunityEvent()),
                  child: BuildCommunitysWidget(communities: state.communities));
            }
            return const Text("helo");
          },
        ));
  }
}
