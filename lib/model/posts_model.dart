class Post {
  int id;
  String title;
  String body;
  int likes;
  int dislikes;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.likes,
    required this.dislikes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      likes: json['reactions']['likes'] ?? 0,
      dislikes: json['reactions']['dislikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'reactions': {
        'likes': likes,
        'dislikes': dislikes,
      },
    };
  }
}
