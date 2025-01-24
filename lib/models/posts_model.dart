import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostsModel extends ChangeNotifier{

  int? id;
  String? title;
  String? body;

  PostsModel({required this.id, required this.title, required this.body});

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

}