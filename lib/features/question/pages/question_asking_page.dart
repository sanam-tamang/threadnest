// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/common/utils/app_dialog.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/file_picker.dart';
import 'package:threadnest/common/utils/image_picker.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/common/widgets/app_text_form_field.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/get_joined_community_bloc/get_community_bloc.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/widgets/community_widget.dart';
import 'package:threadnest/features/question/blocs/post_question_bloc/post_question_bloc.dart';
import 'package:threadnest/features/question/models/question.dart';

class QuestionAskingPage extends StatefulWidget {
  const QuestionAskingPage({
    super.key,
    this.community,
  });

  ///navigated from current community
  final Community? community;
  @override
  State<QuestionAskingPage> createState() => _QuestionAskingPageState();
}

class _QuestionAskingPageState extends State<QuestionAskingPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  File? _imageFile;
  File? _documentFile;
  Community? _selectedCommunity;

  @override
  void initState() {
    _selectedCommunity = widget.community;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Container _buildBottomSheet() {
    Color iconColor = isAnyDocumentPicked() ? Colors.grey : Colors.black87;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      width: double.maxFinite,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          IconButton(
              onPressed: isAnyDocumentPicked() ? null : _pickImage,
              icon: Icon(
                Icons.image_outlined,
                color: iconColor,
              )),
          const Gap(8),
          IconButton(
              onPressed: isAnyDocumentPicked() ? null : _pickDocument,
              icon: Icon(
                Icons.attach_file,
                color: iconColor,
              )),
        ],
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.tonalIcon(
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.swap_vert),
              onPressed: _showCommunities,
              label: _selectedCommunity == null
                  ? const Text("Select a community")
                  : Text(_selectedCommunity!.name)),
          const Gap(4),
          AppBorderlessTextFormField(
            maxLines: null,
            controller: _titleController,
            hint: "Title",
            hintTextStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            textStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          _buildImageWidget(),
          _buildDocumentWidget(),
          const Gap(4),
          AppBorderlessTextFormField(
            maxLines: null,
            controller: _contentController,
            hint: "body text (optional)",
            hintTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      actions: [
        BlocListener<PostQuestionBloc, PostQuestionState>(
          listener: (context, state) async {
            if (state is PostQuestionLoading) {
              await AppProgressIndicator.show2(context);
            } else if (state is PostQuestionLoaded) {
              context.pop();
              context.pop();
              await AppToast.show("post successful");
            } else if (state is PostQuestionFailure) {
              context.pop();

              await AppDialog.error(context, state.failure.message);
            }
          },
          child: FilledButton(
            onPressed: !isPostValid() ? null : _postData,
            child: const Text('Post'),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Future<void> _showCommunities() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close)),
              title: const Text("Post to"),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.surface,
              child:
                  BlocBuilder<GetJoinedCommunityBloc, GetJoinedCommunityState>(
                builder: (context, state) {
                  if (state is GetJoinedCommunityLoaded) {
                    return BuildCommunitysWidget(
                      communities: state.communities,
                      showJoinBtn: false,
                      onTap: (community) {
                        _selectedCommunity = community;
                        setState(() {});
                        context.pop();
                      },
                    );
                  } else if (state is GetJoinedCommunityLoading) {
                    return const AppLoadingIndicator();
                  } else if (state is GetJoinedCommunityFailure) {
                    return AppErrorWidget(
                      failure: state.failure,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        });
  }

  // Widget for displaying image with a close button
  Widget _buildImageWidget() {
    return _imageFile == null
        ? const SizedBox()
        : SizedBox(
            width: double.maxFinite,
            height: 200,
            child: Stack(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton.filledTonal(
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                )
              ],
            ),
          );
  }

  // Widget for displaying document with a close button
  Widget _buildDocumentWidget() {
    return _documentFile == null
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                const SizedBox(width: 8),
                Text(_documentFile?.path.split('/').last ?? 'No document'),
                const Spacer(),
                IconButton.filledTonal(
                  color: Colors.grey,
                  onPressed: () {
                    setState(() {
                      _documentFile = null;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          );
  }

  bool isAnyDocumentPicked() {
    bool isImagePicked = _imageFile == null ? false : true;
    bool isDocumentPicked = _documentFile == null ? false : true;

    return isImagePicked || isDocumentPicked;
  }

  bool isPostValid() {
    bool hasTitle = _titleController.text.isNotEmpty;
    bool hasCommunity = _selectedCommunity == null ? false : true;

    return hasTitle || hasCommunity;
  }

  void _postData() {
    final question = PostQuestion(
        title: _titleController.text,
        content: _contentController.text,
        communityId: _selectedCommunity!.id,
        imageFile: _imageFile,
        documentFile: _documentFile);
    sl<PostQuestionBloc>().add(PostQuestionEvent(question: question));
  }

  Future<void> _pickImage() async {
    _imageFile = await AppImagePicker.pickImageFromGallery();
    setState(() {});
  }

  Future<void> _pickDocument() async {
    _documentFile = await AppFilePicker.pick();
    setState(() {});
  }
}
