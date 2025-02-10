// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/widgets/join_community_listener.dart';

class BuildCommunitysWidget extends StatefulWidget {
  const BuildCommunitysWidget({
    super.key,
    required this.communities,
    this.physics,
    this.showJoinBtn = true,
    this.shrinkWrap = false,
    this.onTap,
  });

  final List<Community> communities;
  final ScrollPhysics? physics;
  final bool showJoinBtn;
  final bool shrinkWrap;
  final void Function(Community community)? onTap;

  @override
  State<BuildCommunitysWidget> createState() => _BuildCommunitysWidgetState();
}

class _BuildCommunitysWidgetState extends State<BuildCommunitysWidget> {
  final Set<String> _joinedCommunities = {};
  late JoinCommunityBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<JoinCommunityBloc>();
  }

  void _onCommunityJoined(String communityId) {
    setState(() {
      _joinedCommunities.add(communityId);
    });
    _bloc.add(JoinCommunityEvent(communityId));
  }

  @override
  Widget build(BuildContext context) {
    return JoinCommunityListener(
      bloc: _bloc,
      child: widget.communities.isEmpty
          ? const Text("You haven't joined any communities")
          : ListView.builder(
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: widget.communities.length,
              itemBuilder: (context, index) {
                final community = widget.communities[index];
      
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () =>
                          widget.onTap != null ? widget.onTap!(community) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Community Image
                            SizedBox(
                              width: 40,
                              child: AppCachedNetworkImage(
                                isCircular: true,
                                imageUrl: community.imageUrl,
                              ),
                            ),
                            const Gap(8),
      
                            // Community Name and Description
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    community.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  community.description != null
                                      ? Text(
                                          community.description!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
      
                            // Join Button
                            widget.showJoinBtn
                                ? JoinButton(
                                    isJoined: community.isMember == true
                                        ? community.isMember!
                                        : _joinedCommunities
                                            .contains(community.id),
                                    communityId: community.id,
                                    onJoin: _onCommunityJoined,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class JoinButton extends StatelessWidget {
  const JoinButton({
    super.key,
    required this.communityId,
    required this.isJoined,
    required this.onJoin,
  });

  final String communityId;
  final bool isJoined;
  final void Function(String) onJoin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: FilledButton.tonal(
        onPressed: isJoined ? null : () => onJoin(communityId),
        child: Text(isJoined ? "Joined" : "Join"),
      ),
    );
  }
}
