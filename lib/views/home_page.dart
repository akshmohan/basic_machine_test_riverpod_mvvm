// ignore_for_file: avoid_unnecessary_containers, unused_field, prefer_final_fields

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
    // Watch the current tab index from the currentIndexProvider.
    final currentIndex = ref.watch(currentIndexProvider);

    // Watch the state of the postsProvider (which likely holds data and loading state for posts).
    final postsViewModel = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          // Logout button in the AppBar.
          IconButton(
            onPressed: () {
              // Show a confirmation dialog for logout.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      // Option to cancel logout and close the dialog.
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog.
                        },
                        child: const Text("No"),
                      ),
                      // Option to confirm logout.
                      TextButton(
                        onPressed: () {
                          // Trigger the logout action through the authenticationProvider.
                          ref.read(authenticationProvider.notifier).logout();
                          Navigator.of(context).pop(); // Close the dialog.

                          // Navigate to the LoginPage after logout.
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
            icon: const Icon(Icons.logout), // Logout icon.
          ),
        ],
      ),
      // The body changes based on the selected tab index.
      body: currentIndex == 0
          ? // If the selected tab is "Profile" (index 0):
            const Center(
              child: Text("Profile Page"), // Placeholder for the Profile tab.
            )
          : // If the selected tab is "Posts" (index 1):
            postsViewModel.isLoadingPosts
              ? // Show a loading spinner while posts are being fetched.
                const Center(child: CircularProgressIndicator())
              : // Show a list of posts when data is loaded.
                ListView.builder(
                  itemCount: postsViewModel.postsList.length, // Total number of posts.
                  itemBuilder: (context, index) {
                    final post = postsViewModel.postsList[index]; // Access each post.
                    return Card(
                      elevation: 4, // Elevation for shadow effect.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners.
                        side: BorderSide(
                          color: Colors.grey.shade800, // Border color.
                          width: 1.0, // Border width.
                        ),
                      ),
                      child: ListTile(
                        // Display the post title.
                        title: Text(
                          post.title.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display the post body.
                        subtitle: Text(post.body.toString()),
                        // Display a circular avatar with the post ID.
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue, // Background color.
                          child: Text(
                            post.id.toString(), // Post ID inside the avatar.
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
      // Bottom navigation bar with the "Profile" tab first and "Posts" tab second.
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed style navigation bar.
        currentIndex: currentIndex, // The current selected tab index.
        onTap: (index) {
          // Update the selected tab index using the currentIndexProvider.
          ref.read(currentIndexProvider.notifier).state = index;

          // Automatically fetch posts when the "Posts" tab (index 1) is selected.
          if (index == 1) {
            ref.read(postsProvider.notifier).getAllPosts();
          }
        },
        items: const [
          // First tab for "Profile".
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          // Second tab for "Posts".
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Posts'),
        ],
      ),
    );
  }
}