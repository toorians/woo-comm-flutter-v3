// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postsFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

Post postFromJson(String str) => Post.fromJson(json.decode(str));

class Post {
  Post({
    required this.date,
    required this.id,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.image,
    required this.authorDetails,
    required this.categoryName,
    required this.category
  });

  DateTime date;
  int id;
  String link;
  Content title;
  Content content;
  Content excerpt;
  Thumbnail image;
  AuthorDetails authorDetails;
  String categoryName;
  int category;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    id: json["id"] == null ? 0 : json["id"],
    link: json["link"] == null ? null : json["link"],
    title: json["title"] == null ? Content.fromJson({}) : Content.fromJson(json["title"]),
    content: json["content"] == null ? Content.fromJson({}) : Content.fromJson(json["content"]),
    excerpt: json["excerpt"] == null ? Content.fromJson({}) : Content.fromJson(json["excerpt"]),
    image: json["image"] == null ? Thumbnail.fromJson({}) : Thumbnail.fromJson(json["image"]),
    authorDetails: json["author_details"] == null || json["author_details"] is bool ? AuthorDetails.fromJson({}) : AuthorDetails.fromJson(json["author_details"]),
    categoryName: json["category_name"] == null ? '' : json["category_name"],
    category: json["category"] == null ? 0 : json["category"],
  );
}

class AuthorDetails {
  AuthorDetails({
    required this.name,
    required this.avatar,
  });

  String name;
  String avatar;

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => AuthorDetails(
    name: json["name"] == null ? '' : json["name"],
    avatar: json["avatar"] == null ? '' : json["avatar"],
  );
}

class Content {
  Content({
    required this.rendered,
  });

  String rendered;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"] == null ? '' : json["rendered"],
  );
}

class Thumbnail {
  Thumbnail({
    required this.id,
    required this.src,
  });

  dynamic id;
  String src;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    id: json["id"],
    src: json["src"] == null ? '' : json["src"],
  );

}
