import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:threadnest/common/utils/app_dialog.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/image_picker.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/create_community_bloc/create_community_bloc.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final _formKey = GlobalKey<FormState>();
  final _communityNameController = TextEditingController();
  final _communityDescriptionController = TextEditingController();

  late final PageController _pageController;
  int _currentPage = 1;

  File? _communityImage;
  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        _currentPage = _pageController.page!.floor() + 1;
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    _communityDescriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$_currentPage/2"),
          )),
          const Gap(16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildCommunityNameAndDescriptioin(),
            _buildCommunityProfile(),
          ],
        ),
      ),
    );
  }

  Padding _buildCommunityNameAndDescriptioin() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              "Tell us about your community",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Gap(20),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Community Name
                  TextFormField(
                    controller: _communityNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter community name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a community name';
                      }
                      return null;
                    },
                  ),
                  const Gap(16),

                  // Community Description
                  TextFormField(
                    controller: _communityDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter community description',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),

                  // Submit Button
                  Center(
                    child: FilledButton(
                      onPressed: _nextPage,
                      child: const Text(
                        'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: _communityImage != null
                    ? FileImage(_communityImage!)
                    : null,
                radius: 100,
              ),
              Positioned(
                right: -5,
                bottom: -5,
                child: Container(
                  transform: Matrix4.identity()
                    ..scale(0.7)
                    ..rotateZ(12),
                  child: IconButton.outlined(
                      onPressed: _pickCommunityImage,
                      icon: const Icon(LineIcons.edit)),
                ),
              )
            ],
          ),
          const Gap(30),
          BlocListener<CreateCommunityBloc, CreateCommunityState>(
            listener: (context, state) async {
              if (state is CreateCommunityLoading) {
                await AppProgressIndicator.show2(context);
              } else if (state is CreateCommunityFailure) {
                context.pop();

                await AppDialog.error(context, state.failure.message);
              } else if (state is CreateCommunityLoaded) {
                context.pop();
                context.pop();

                AppToast.show("Community created");
              }
            },
            child: FilledButton(
                onPressed: _createCommunity,
                child: const Text("Create Community")),
          )
        ],
      ),
    );
  }

  void _pickCommunityImage() async {
    _communityImage = await AppImagePicker.pickImageFromGallery();
    setState(() {});
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _createCommunity() {
    if (_formKey.currentState!.validate()) {
      final name = _communityNameController.text;
      final description = _communityDescriptionController.text;

      sl<CreateCommunityBloc>().add(CreateCommunityEvent(
          name: name, description: description, imageFile: _communityImage));
    }
  }
}
