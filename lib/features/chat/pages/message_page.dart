import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/chat/blocs/message_bloc/message_bloc.dart';
import 'package:threadnest/features/chat/models/message.dart';
import 'package:threadnest/features/chat/widget/chat_text_fiel.dart';

import 'package:threadnest/features/profile/models/user.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    required this.chatRoomId,
    required this.chatPartner,
  });

  final String chatRoomId;
  final User chatPartner;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late ScrollController _scrollController;
  bool _isNearBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    sl<MessageBloc>().add(GetMessageEvent(roomId: widget.chatRoomId));
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      _isNearBottom = position.pixels >= (position.maxScrollExtent - 100);
    }
  }

  void scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    final bottomOffset = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        bottomOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
      );
    } else {
      _scrollController.jumpTo(bottomOffset);
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Hero(
              tag: 'profile-${widget.chatPartner.id}',
              child: AppCachedNetworkImage(
                imageUrl: widget.chatPartner.imageUrl,
                isCircular: true,
                radius: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatPartner.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Online', //TODO: need make this dynamic
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call_outlined),
            onPressed: () {
              //TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              //TODO: Implement voice call
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is MessageLoaded && _isNearBottom) {
                  scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MessageLoaded) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        _scrollListener();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final previousMessage =
                            index < state.messages.length - 1
                                ? state.messages[index + 1]
                                : null;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scrollToBottom(animated: false);
                        });
                        if (index == state.messages.length) {
                          return const SizedBox(height: 170);
                        }

                        return ChatBubbleContainer(
                          message: message,
                          previousMessage: previousMessage,
                          chatPartner: widget.chatPartner,
                        );
                      },
                    ),
                  );
                } else if (state is MessageFailure) {
                  return AppErrorWidget(failure: state.failure);
                }
                return const SizedBox();
              },
            ),
          ),
          MessageTextField(
            roomId: widget.chatRoomId,
            onMessageSent: () {
              scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubbleContainer extends StatelessWidget {
  const ChatBubbleContainer({
    super.key,
    required this.message,
    required this.chatPartner,
    this.previousMessage,
  });

  final Message message;
  final Message? previousMessage;
  final User chatPartner;

  bool get _showTimeHeader {
    if (previousMessage == null) return true;
    final previousTime = DateTime.parse(previousMessage!.timestamp);
    final currentTime = DateTime.parse(message.timestamp);
    return currentTime.difference(previousTime).inMinutes > 30;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showTimeHeader) ...[
          const Gap(8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatMessageDate(message.timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
          const Gap(8),
        ],
        ChatBubble(
          message: message,
          chatPartner: chatPartner,
        ),
      ],
    );
  }

  String _formatMessageDate(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();

    if (date.day == now.day) {
      return DateFormat('h:mm a').format(date);
    } else if (date.difference(now).inDays.abs() < 7) {
      return DateFormat('EEEE h:mm a').format(date);
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.chatPartner,
    required this.message,
  });

  final User chatPartner;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final isChatPartner = chatPartner.id == message.senderId;
    final bubbleColor = isChatPartner
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primary;
    final textColor = isChatPartner
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : Theme.of(context).colorScheme.onPrimary;

    return Align(
      alignment: isChatPartner ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          left: isChatPartner ? 8 : 60,
          right: isChatPartner ? 60 : 8,
          bottom: 2,
          top: 2,
        ),
        child: Column(
          crossAxisAlignment:
              isChatPartner ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: Radius.circular(isChatPartner ? 5 : 20),
                  bottomRight: Radius.circular(isChatPartner ? 20 : 5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                ),
              ),
            ),
            const Gap(2),
            Text(
              DateFormat('h:mm a').format(DateTime.parse(message.timestamp)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
