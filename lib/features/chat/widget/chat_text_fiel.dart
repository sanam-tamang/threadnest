import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/core/theme/box_shadow.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/chat/blocs/send_message_bloc/send_message_bloc.dart';

class MessageTextField extends StatefulWidget {
  final String roomId;
  final VoidCallback onMessageSent;
  const MessageTextField(
      {super.key, required this.roomId, required this.onMessageSent});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  late TextEditingController _messageController;
  late FocusNode _messaeFocus;
  bool _isKeywordOpen = false;
  bool _shouldSendMessage = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController()
      ..addListener(() {
        setState(() {
          _shouldSendMessage = _messageController.text.trim().isNotEmpty;
        });
      });
    _messaeFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isKeywordOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    !_isKeywordOpen ? _messaeFocus.unfocus() : ();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messaeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: AppBoxShadow.postBoxShadow(context),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: 12, top: 8, right: _isKeywordOpen ? 0 : 12, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4)),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                // onTapOutside: (event) => _messaeFocus.unfocus(),
                controller: _messageController,
                focusNode: _messaeFocus,
                decoration: const InputDecoration(
                  hintText: 'Enter your message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          BlocConsumer<SendMessageBloc, SendMessageState>(
            listener: (context, state) {
              if (state is SendMessageFailure) {
                AppToast.show(state.failure.message);
              }
            },
            builder: (context, state) {
              if (state is SendMessageLoading) {
                return const CircularProgressIndicator();
              } else {
                return IconButton.filled(
                  onPressed: _shouldSendMessage ? _onMessageSend : null,
                  icon: const Icon(
                    Icons.send_outlined,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _onMessageSend() {
    widget.onMessageSent();
    final content = _messageController.text;
    sl<SendMessageBloc>()
        .add(SendMessageEvent(roomId: widget.roomId, content: content));
    _messageController.clear();
  }
}
