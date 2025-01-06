import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/features/chat/blocs/chat_room_bloc/chat_room_bloc.dart';
import 'package:threadnest/features/chat/models/room.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  void initState() {
    super.initState();
    // sl<ChatRoomBloc>().add(const GetChatRoomEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              title: const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_square),
                  onPressed: () {
                    // Implement new message creation
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      selected: true,
                      label: const Text('All'),
                      onSelected: (bool selected) {},
                    ),
                    const Gap(8),
                    FilterChip(
                      selected: false,
                      label: const Text('Unread'),
                      onSelected: (bool selected) {},
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ChatRoomBloc, ChatRoomState>(
              builder: (context, state) {
                if (state is ChatRoomLoading) {
                  return const SliverFillRemaining(
                    child: AppLoadingIndicator(),
                  );
                } else if (state is ChatRoomLoaded) {
                  if (state.rooms.isEmpty) {
                    return const SliverFillRemaining(
                      child: _EmptyChatsView(),
                    );
                  }
                  return SliverList.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final room = state.rooms[index];
                      return _ChatRoomTile(room: room);
                    },
                  );
                } else if (state is ChatRoomFailure) {
                  return SliverFillRemaining(
                    child: AppErrorWidget(failure: state.failure),
                  );
                }
                return const SliverToBoxAdapter();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  const _ChatRoomTile({
    required this.room,
  });

  final ChatRoom room;

  String _formatLastMessageTime(String? timestamp) {
    if (timestamp == null) return '';

    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(date); // Mon, Tue, etc.
    } else {
      return DateFormat('MM/dd/yy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'message',
          pathParameters: {'chatRoomId': room.id},
          extra: room.chatUser,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'profile-${room.chatUser.id}',
                  child: AppCachedNetworkImage(
                    imageUrl: room.chatUser.imageUrl,
                    isCircular: true,
                    radius: 28,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.chatUser.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatLastMessageTime(room.lastMessageTimestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: room.isLastMessageRead == false
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.lastMessage ?? 'No messages yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: room.isLastMessageRead == false
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.outline,
                            fontWeight: room.isLastMessageRead == false
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (room.isLastMessageRead == false) const Gap(8),
                      if (room.isLastMessageRead == false)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatsView extends StatelessWidget {
  const _EmptyChatsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const Gap(16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const Gap(8),
          Text(
            'Start a new chat with your friends',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const Gap(24),
          FilledButton.icon(
            onPressed: () {
              // Implement new chat creation
            },
            icon: const Icon(Icons.add),
            label: const Text('Start a new chat'),
          ),
        ],
      ),
    );
  }
}
