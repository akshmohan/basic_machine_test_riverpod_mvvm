import 'dart:convert';
import 'package:mvvm/models/posts_model.dart';
import 'package:http/http.dart' as http;

class PostsRepository {
  Future<List<PostsModel>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        List<PostsModel> fetchedPosts = (json.decode(response.body) as List)
            .map((post) => PostsModel.fromJson(post))
            .toList();
        return fetchedPosts;
      } else {
        throw Exception(
            "Failed to load posts: Exception${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
