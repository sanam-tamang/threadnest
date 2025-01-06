import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/image_picker.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_text_form_field.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/profile/blocs/edit_user_bloc/edit_user_bloc.dart';
import 'package:threadnest/features/profile/blocs/user_bloc/user_bloc.dart';
import 'package:threadnest/features/profile/models/user.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({
    super.key,
    required this.user,
  });
  final User user;
  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  File? _imageFile;
  late String? imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    imageUrl = widget.user.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: ListView(
              children: [
                _profileImage(),
                const Gap(36),
                AppTextFormField(
                  hint: "Name",
                  controller: _nameController,
                  validator: (name) =>
                      name != null ? null : "Name can't be empty",
                ),
                const Gap(18),
                AppTextFormField(
                  hint: "Bio",
                  controller: _bioController,
                ),
                const Gap(18),
                BlocListener<EditUserBloc, EditUserState>(
                  listener: (context, state) async {
                    if (state is EditUserLoading) {
                      await AppProgressIndicator.show2(context);
                    } else if (state is EditUserLoaded) {
                      context.pop();
                      context.pop();
                      sl<UserBloc>().add(GetUserEvent(
                          currentlyVisitedProfileId: widget.user.id, refresh: true));
                      AppToast.show("Profile updated");
                    } else if (state is EditUserFailure) {
                      context.pop();
                      context.pop();
                      AppToast.show(
                          "Failed to update profile ${state.failure.message}");
                    }
                  },
                  child: FilledButton(
                      onPressed: _onEditUserProfile,
                      child: const Text("Update")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return SizedBox(
      height: 160,
      width: double.maxFinite,
      child: Stack(
        children: [
          _imageFile != null || imageUrl == null
              ? Container(
                  height: 160,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      image: _imageFile != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                _imageFile!,
                              ))
                          : null),
                  child: _noImagePlaceHolder(),
                )
              : SizedBox(
                  height: 160,
                  width: double.maxFinite,
                  child: AppCachedNetworkImage(imageUrl: imageUrl)),
          imageUrl != null || _imageFile != null
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          imageUrl = null;
                          _imageFile = null;
                        });
                      },
                      icon: const Icon(Icons.close)))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _noImagePlaceHolder() {
    return _imageFile == null
        ? IconButton(
            onPressed: () async {
              final imageFile = await AppImagePicker.pickImageFromGallery();

              setState(() {
                _imageFile = imageFile;
              });
            },
            icon: Icon(
              Icons.image,
              size: 100,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
            ))
        : const SizedBox();
  }

  void _onEditUserProfile() {
    sl<EditUserBloc>().add(EditUserEvent(
        name: _nameController.text,
        bio: _bioController.text,
        imageFile: _imageFile));
  }
}
