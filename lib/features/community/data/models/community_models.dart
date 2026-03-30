import '../../domain/entities/community_entities.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userName,
    required super.userRole,
    required super.userAvatar,
    required super.timeAgo,
    required super.content,
    super.postImage,
    required super.likes,
    required super.comments,
    super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userName: json['userName'] as String,
      userRole: json['userRole'] as String,
      userAvatar: json['userAvatar'] as String,
      timeAgo: json['timeAgo'] as String,
      content: json['content'] as String,
      postImage: json['postImage'] as String?,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userRole': userRole,
      'userAvatar': userAvatar,
      'timeAgo': timeAgo,
      'content': content,
      'postImage': postImage,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
    };
  }
}

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.memberCount,
    required super.image,
    super.isJoined,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      memberCount: json['memberCount'] as String,
      image: json['image'] as String,
      isJoined: json['isJoined'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberCount': memberCount,
      'image': image,
      'isJoined': isJoined,
    };
  }
}
