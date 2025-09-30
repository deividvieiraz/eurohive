class RankingUser {
  final String id;
  final String name;
  final String email;
  final String avatarPath;
  final int posts;
  final int ideas;
  final int likes;
  final int comments;
  final int totalScore;
  final int position;

  RankingUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarPath,
    required this.posts,
    required this.ideas,
    required this.likes,
    required this.comments,
    required this.totalScore,
    required this.position,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarPath: json['avatarPath'],
      posts: json['posts'],
      ideas: json['ideas'],
      likes: json['likes'],
      comments: json['comments'],
      totalScore: json['totalScore'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarPath': avatarPath,
      'posts': posts,
      'ideas': ideas,
      'likes': likes,
      'comments': comments,
      'totalScore': totalScore,
      'position': position,
    };
  }
}
