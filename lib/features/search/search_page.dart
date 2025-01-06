import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/models/post_model.dart';
import 'package:threadnest/router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<GetPost> _searchResults = [];
  late List<GetPost> _allPosts; 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
 
      _searchResults = _allPosts.where((post) {
        return post.title.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
        actions: [
          IconButton(
            onPressed: () {
              _controller.clear();
              setState(() {
                _searchResults = []; 
              });
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onChanged: _onSearch, 
                decoration: InputDecoration(
                  hintText: 'Search by title or content...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<GetPostsBloc, GetPostState>(
                builder: (context, state) {
                  if (state is GetPostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetPostLoaded) {
                    _allPosts = state.posts['normal']!; 
                    if (_searchResults.isEmpty) {
                      _searchResults = _allPosts;
                    }

                    return _searchResults.isEmpty
                        ? const Center(child: Text('No posts found'))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final post = _searchResults[index];
                              return ListTile(
                                title: Text(post.title),
                                subtitle: post.content!=null? Text(post.content!): null,
                                onTap: () => context.pushNamed(
                                  AppRouteName.questionDetail,
                                  queryParameters: {'postKey': 'normal'},
                                  pathParameters: {"postId": post.id},
                                ),
                              );
                            },
                          );
                  } else if (state is GetPostFailure) {
                    return AppErrorWidget(failure: state.failure);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
