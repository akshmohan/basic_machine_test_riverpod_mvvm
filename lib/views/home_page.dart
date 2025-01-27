// ignore_for_file: avoid_unnecessary_containers, unused_field, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm/viewModels/authentication_viewModel.dart';
import 'package:mvvm/viewModels/posts_viewModel.dart';
import 'package:mvvm/views/login_page.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
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
                      TextButton(
                        onPressed: () {
                          ref.read(authenticationProvider.notifier).logout();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: currentIndex == 0
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          
                          color: Colors.grey.shade800,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            'Username: ${ref.watch(authenticationProvider).username}'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey.shade800,
                          width: 1.0,
                        )),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            'Token: ${ref.watch(authenticationProvider).accessToken}'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : postsViewModel.isLoadingPosts
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: postsViewModel.postsList.length,
                  itemBuilder: (context, index) {
                    final post = postsViewModel.postsList[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey.shade800,
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          post.title.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(post.body.toString()),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            post.id.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).state = index;
          if (index == 1) {
            ref.read(postsProvider.notifier).getAllPosts();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Posts'),
        ],
      ),
    );
  }
}
