// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm/models/posts_model.dart';
import 'package:mvvm/repositories/posts_repository.dart';

class PostsViewmodel with ChangeNotifier {

   final PostsRepository _postsRepository;


  List<PostsModel> _posts = [];
  bool _isLoading = false;

  PostsViewmodel(this._postsRepository);

  List<PostsModel> get postsList => _posts;

  bool get isLoadingPosts => _isLoading;



  Future<void> getAllPosts() async {
    _isLoading = true;
    notifyListeners(); 

    try {
      _posts = await _postsRepository.fetchPosts();
    } catch (e) {
     throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


final postsProvider = ChangeNotifierProvider<PostsViewmodel>((ref) {
  final postsRepository = PostsRepository(); 
  return PostsViewmodel(postsRepository); 
});