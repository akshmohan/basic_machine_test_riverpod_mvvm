import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm/viewModels/authentication_viewModel.dart';
import 'package:mvvm/viewModels/posts_viewModel.dart';
import 'package:mvvm/views/login_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsViewModel = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No"),
                        ),
                        TextButton(onPressed: () {
                          ref.read(authenticationProvider.notifier).logout();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        }, child: const Text("Yes"))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: postsViewModel.isLoadingPosts
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: postsViewModel.postsList.length,
              itemBuilder: (context, index) {
                final post = postsViewModel.postsList[index];
                return ListTile(
                  title: Text(post.title.toString()),
                  subtitle: Text(post.body.toString()),
                  leading: CircleAvatar(
                    child: Text(post.id.toString()),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postsViewModel.getAllPosts();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
