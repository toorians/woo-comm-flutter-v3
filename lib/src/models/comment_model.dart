// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);
class CommentsModel {
  final List<Comment> comments;

  CommentsModel({
    required this.comments,
  });

  factory CommentsModel.fromJson(List<dynamic> parsedJson) {

    List<Comment> comments = [];
    comments = parsedJson.map((i)=>Comment.fromJson(i)).toList();

    return new CommentsModel(comments : comments);
  }

}

class Comment {
  int id;
  int post;
  int parent;
  int author;
  String authorName;
  String authorUrl;
  DateTime date;
  DateTime dateGmt;
  Content content;
  String status;
  String type;
  Map<String, String> authorAvatarUrls;

  Comment({
    required this.id,
    required this.post,
    required this.parent,
    required this.author,
    required this.authorName,
    required this.authorUrl,
    required this.date,
    required this.dateGmt,
    required this.content,
    required this.status,
    required this.type,
    required this.authorAvatarUrls,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"] == null ? 0 : json["id"],
    post: json["post"] == null ? 0 : json["post"],
    parent: json["parent"] == null ? 0 : json["parent"],
    author: json["author"] == null ? 0 : json["author"],
    authorName: json["author_name"] == null ? '' : json["author_name"],
    authorUrl: json["author_url"] == null ? '' : json["author_url"],
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    dateGmt: json["date_gmt"] == null ? DateTime.now() : DateTime.parse(json["date_gmt"]),
    content: json["content"] == null ? Content.fromJson({}) : Content.fromJson(json["content"]),
    status: json["status"] == null ? '' : json["status"],
    type: json["type"] == null ? '' : json["type"],
    authorAvatarUrls: json["author_avatar_urls"] == null ? Map() : Map.from(json["author_avatar_urls"]).map((k, v) => MapEntry<String, String>(k, v)),
  );
}

class Content {
  String rendered;

  Content({
    required this.rendered,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"] == null ? '' : json["rendered"],
  );
}

class Links {
  //List<Collection> self;
  //List<Collection> collection;
  List<Author> author;
  //List<Up> up;

  Links({
    //required this.self,
    //required this.collection,
    required this.author,
    //required this.up,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    //self: json["self"] == null ? [] : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    //collection: json["collection"] == null ? [] : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    author: json["author"] == null ? [] : List<Author>.from(json["author"].map((x) => Author.fromJson(x))),
    //up: json["up"] == null ? [] : List<Up>.from(json["up"].map((x) => Up.fromJson(x))),
  );
}

class Author {
  bool embeddable;
  String href;

  Author({
    required this.embeddable,
    required this.href,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    embeddable: json["embeddable"] == null ? '' : json["embeddable"],
    href: json["href"] == null ? '' : json["href"],
  );
}
