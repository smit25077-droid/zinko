import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import '../models/community_models.dart';

abstract class CommunityRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<PostModel> toggleLikePost(String id);
  Future<List<GroupModel>> getGroups();
  Future<GroupModel> toggleJoinGroup(String id);
  Future<List<PersonEntity>> getPeople();
  Future<PersonEntity> toggleConnection(String id);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final List<PostModel> _mockPosts = [
    PostModel(
      id: 'post1',
      userName: 'Alex Rivera',
      userRole: 'Product Designer',
      userAvatar: 'https://i.pravatar.cc/150?u=post1',
      timeAgo: '2h ago',
      content: 'Just finished a great co-working session at Workspace Central. The vibes are amazing! 🚀',
      likes: 24,
      comments: 5,
      isLiked: false,
    ),
    PostModel(
      id: 'post2',
      userName: 'Sarah Chen',
      userRole: 'Fullstack Developer',
      userAvatar: 'https://i.pravatar.cc/150?u=post2',
      timeAgo: '5h ago',
      content: 'Anyone up for a quick coffee chat about Flutter? I\'m currently at Cafe Nero.',
      likes: 12,
      comments: 3,
      isLiked: true,
    ),
  ];

  final List<GroupModel> _mockGroups = [
    GroupModel(
      id: 'group1',
      name: 'Designers in London',
      memberCount: '1.2k members',
      image: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=200',
      isJoined: true,
    ),
    GroupModel(
      id: 'group2',
      name: 'Flutter Developers',
      memberCount: '800 members',
      image: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=200',
      isJoined: false,
    ),
  ];

  final List<PersonEntity> _mockPeople = [
    PersonEntity(
      id: 'u1',
      name: 'Michael Chen',
      role: 'Full Stack Dev',
      bio: 'Full Stack Developer with a passion for building scalable web applications.',
      avatarUrl: 'https://i.pravatar.cc/300?u=1',
      location: 'London, UK',
      connections: 220,
      rating: 4.8,
      skills: ['Flutter', 'React', 'NodeJS'],
      isVerified: true,
      lat: 51.5101,
      lng: -0.1303,
      isConnected: false,
    ),
    PersonEntity(
      id: 'u2',
      name: 'Sophie Turner',
      role: 'UI/UX Designer',
      bio: 'Creative designer who loves crafting delightful experiences.',
      avatarUrl: 'https://i.pravatar.cc/300?u=2',
      location: 'Shoreditch, London',
      connections: 185,
      rating: 4.9,
      skills: ['Figma', 'Prototyping'],
      isVerified: true,
      lat: 51.5051,
      lng: -0.1103,
      isConnected: true,
    ),
  ];

  @override
  Future<List<PostModel>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPosts;
  }

  @override
  Future<PostModel> toggleLikePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockPosts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _mockPosts[index];
      final updated = PostModel(
        id: p.id,
        userName: p.userName,
        userRole: p.userRole,
        userAvatar: p.userAvatar,
        timeAgo: p.timeAgo,
        content: p.content,
        postImage: p.postImage,
        likes: p.isLiked ? p.likes - 1 : p.likes + 1,
        comments: p.comments,
        isLiked: !p.isLiked,
      );
      _mockPosts[index] = updated;
      return updated;
    }
    throw Exception('Post not found');
  }

  @override
  Future<List<GroupModel>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockGroups;
  }

  @override
  Future<GroupModel> toggleJoinGroup(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockGroups.indexWhere((g) => g.id == id);
    if (index != -1) {
      final g = _mockGroups[index];
      final updated = GroupModel(
        id: g.id,
        name: g.name,
        memberCount: g.memberCount,
        image: g.image,
        isJoined: !g.isJoined,
      );
      _mockGroups[index] = updated;
      return updated;
    }
    throw Exception('Group not found');
  }

  @override
  Future<List<PersonEntity>> getPeople() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPeople;
  }

  @override
  Future<PersonEntity> toggleConnection(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockPeople.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _mockPeople[index];
      final updated = PersonEntity(
        id: p.id,
        name: p.name,
        role: p.role,
        bio: p.bio,
        avatarUrl: p.avatarUrl,
        location: p.location,
        connections: p.isConnected ? p.connections - 1 : p.connections + 1,
        rating: p.rating,
        skills: p.skills,
        isVerified: p.isVerified,
        lat: p.lat,
        lng: p.lng,
        isConnected: !p.isConnected,
      );
      _mockPeople[index] = updated;
      return updated;
    }
    throw Exception('Person not found');
  }
}
