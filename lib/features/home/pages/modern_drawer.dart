import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/widgets/community_widget.dart';
import 'package:threadnest/router.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late final GetJoinedCommunityBloc _bloc;
  @override
  void initState() {
    _bloc = sl<GetJoinedCommunityBloc>();
    if (_bloc.state is! GetJoinedCommunityLoaded) {
      _bloc.add(const GetJoinedCommunityEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            children: [
              const Divider(
                height: 0.0001,
              ),
              ExpansionTile(
                minTileHeight: 50,
                shape: const Border(),
                initiallyExpanded: true,
                maintainState: true,
                title: const Text(
                  "Your communities",
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            context.pushNamed(AppRouteName.createCommunity),
                        label: const Text("Create a community")),
                  ),
                  BlocBuilder<GetJoinedCommunityBloc, GetJoinedCommunityState>(
                    builder: (context, state) {
                      if (state is GetJoinedCommunityLoading) {
                        return const AppLoadingIndicator();
                      }
                      if (state is GetJoinedCommunityLoaded) {
                        return BuildCommunitysWidget(
                            onTap: (Community community) => context.pushNamed(
                                AppRouteName.communityPage,
                                extra: community.copyWith(isMember: true)),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            showJoinBtn: false,
                            communities: state.communities);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
              const Gap(8),
              const Divider(
                height: 0.0001,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
