import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/home/pages/modern_drawer.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/models/post_model.dart';
import 'package:threadnest/features/post/widgets/post_card.dart';
import 'package:threadnest/features/search/search_page.dart';
import 'package:threadnest/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetPostsBloc _qBloc;

  @override
  void initState() {
    super.initState();
    _qBloc = sl<GetPostsBloc>();
  }

  Future<void> _onRefresh() async {
    _qBloc.add(const GetPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: isLightMode ? Colors.white : Colors.black45,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          drawer: const DrawerPage(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  scrolledUnderElevation: 0,
                  title: const Text("Threadnest"),
                  floating: true,
                  actions: [
                    IconButton.filledTonal(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Dialog(
                                  child: SearchPage(),
                                );
                              });
                        },
                        icon: const Icon(Icons.search))
                  ],
                  // backgroundColor:
                  //     Theme.of(context).colorScheme.surfaceContainerLowest,
                ),
              ];
            },
            body: BlocBuilder<GetPostsBloc, GetPostState>(
              builder: (context, state) {
                if (state is GetPostLoading) {
                  return const AppLoadingIndicator();
                } else if (state is GetPostLoaded) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: CustomScrollView(
                      slivers: [
                        // Horizontal scrolling section
                        _horizontalScrolling(state),
                        // Vertical SliverList
                        _verticalScrolling(state),
                      ],
                    ),
                  );
                } else if (state is GetPostFailure) {
                  return AppErrorWidget(failure: state.failure);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  SliverList _verticalScrolling(GetPostLoaded state) {
    return SliverList.builder(
      itemCount: state.posts['normal']!.length,
      itemBuilder: (context, index) {
        final post = state.posts['normal']![index];
        return GestureDetector(
          onTap: () => context.pushNamed(
            AppRouteName.questionDetail,
            queryParameters: {'postKey': 'normal'},
            pathParameters: {"postId": post.id},
          ),
          child: PostCard(
            post: post,
            postKey: 'normal',
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _horizontalScrolling(GetPostLoaded state) {
    // Filter posts to include only those with valid image URLs
    final imagePosts = state.posts['normal']!
        .where((post) => post.imageUrl != null && post.imageUrl != "")
        .toList();

    return SliverToBoxAdapter(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 250,
          viewportFraction: 0.7,
          initialPage: 1,
          // reverse: true,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          scrollDirection: Axis.horizontal,
        ),
        itemCount: imagePosts.length,
        itemBuilder: (context, index, _) {
          final post = imagePosts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () => context.pushNamed(
                AppRouteName.questionDetail,
                queryParameters: {'postKey': 'normal'},
                pathParameters: {"postId": post.id},
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Display the image as the background
                      Positioned.fill(
                        child: AppCachedNetworkImage(
                            borderRadius: 12, imageUrl: post.imageUrl),
                      ),

                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(24, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: _buildCommunityInfo(post)),
                          )),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(107, 0, 0, 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              post.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildCommunityInfo(GetPost post) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: AppCachedNetworkImage(
            imageUrl: post.community.imageUrl,
            isCircular: true,
          ),
        ),
        const Gap(5),
        Text(
          post.community.name,
          overflow: TextOverflow.clip,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const Spacer(),
      ],
    );
  }
}
