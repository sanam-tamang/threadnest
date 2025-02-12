// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/chat/blocs/create_chat_room_bloc/create_chat_room_bloc.dart';
import 'package:threadnest/features/profile/blocs/user_bloc/user_bloc.dart';
import 'package:threadnest/features/profile/models/user.dart';
import 'package:threadnest/features/profile/pages/user_profile_edit_page.dart';
import 'package:threadnest/router.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
    this.currentVisitedUserProfileId,
  });
  final String? currentVisitedUserProfileId;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late bool isCurrentUserAccessingOwnProfile;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    isCurrentUserAccessingOwnProfile =
        widget.currentVisitedUserProfileId == null ||
            widget.currentVisitedUserProfileId ==
                f_auth.FirebaseAuth.instance.currentUser?.uid;
    sl<UserBloc>().add(GetUserEvent(
        currentlyVisitedProfileId: widget.currentVisitedUserProfileId));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isCollapsed) {
      setState(() => _isCollapsed = true);
    } else if (_scrollController.offset <= 200 && _isCollapsed) {
      setState(() => _isCollapsed = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const AppLoadingIndicator();
            } else if (state is UserLoaded) {
              final user = state.user;
              return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        opacity: _isCollapsed ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                                onPressed: () async {
                                  await f_auth.FirebaseAuth.instance.signOut();
                                  context.goNamed(AppRouteName.login);
                                },
                                child: Text("Logout",
                                    style: TextStyle(color: Colors.black)))
                          ],
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppCachedNetworkImage(
                            imageUrl: user.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color.fromRGBO(0, 0, 0, 0.7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const Gap(16),
                          _buildProfileHeader(user),
                          _buildActionButtons(context, user),
                          _buildUserStats(user),
                          _buildBioSection(user),
                          _buildPostsSection(user),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserFailure) {
              return AppErrorWidget(failure: state.failure);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Hero(
            tag: 'profile-${user.id}',
            child: AppCachedNetworkImage(
              imageUrl: user.imageUrl,
              isCircular: true,
              radius: 40,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${user.name}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (!isCurrentUserAccessingOwnProfile) ...[
            Expanded(
              child: BlocListener<CreateChatRoomBloc, CreateChatRoomState>(
                listener: (context, state) async {
                  if (state is CreateChatRoomLoading) {
                    await AppProgressIndicator.show2(context);
                  } else if (state is CreateChatRoomLoaded) {
                    context.pop();
                    context.pushNamed(
                      AppRouteName.message,
                      pathParameters: {'chatRoomId': state.roomId},
                      extra: state.chatPartner,
                    );
                  } else if (state is CreateChatRoomFailure) {
                    context.pop();
                    AppToast.show(state.failure.message);
                  }
                },
                child: ElevatedButton.icon(
                  onPressed: () {
                    sl<CreateChatRoomBloc>().add(
                      CreateChatRoomEvent(chatPartnerUserId: user.id),
                    );
                  },
                  icon: const Icon(Icons.message, size: 20),
                  label: const Text('Message'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add, size: 20),
                label: const Text('Follow'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToProfileEdit(user),
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserStats(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Posts', '11'),
          _buildStatItem('Followers', '123'),
          _buildStatItem('Following', '787'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection(User user) {
    if (user.bio == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        user.bio!,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          height: 1.5,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildPostsSection(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Posts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // if (user.posts == null || user.posts == 0)
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.post_add,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const Gap(16),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        )
        // else
        // Add your posts grid or list here
      ],
    );
  }

  void _navigateToProfileEdit(User user) {
    showDialog(
        context: context,
        builder: (context) => UserProfileEditPage(user: user));
  }
}
