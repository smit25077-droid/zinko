class PostEntity {
  final String id;
  final String userName;
  final String userRole;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? postImage;
  final int likes;
  final int comments;
  final bool isLiked;

  const PostEntity({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.postImage,
    required this.likes,
    required this.comments,
    this.isLiked = false,
  });
}
