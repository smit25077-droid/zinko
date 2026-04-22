import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/entities/community_entities.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();
  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityDataLoaded extends CommunityState {
  final List<PostEntity> posts;
  final List<GroupEntity> groups;
  final List<PersonEntity> people;
  final int tabIndex;
  final int timestamp;

  CommunityDataLoaded({
    required this.posts,
    required this.groups,
    this.people = const [],
    this.tabIndex = 0,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [posts, groups, people, tabIndex, timestamp];

  CommunityDataLoaded copyWith({
    List<PostEntity>? posts,
    List<GroupEntity>? groups,
    List<PersonEntity>? people,
    int? tabIndex,
    int? timestamp,
  }) {
    return CommunityDataLoaded(
      posts: posts ?? this.posts,
      groups: groups ?? this.groups,
      people: people ?? this.people,
      tabIndex: tabIndex ?? this.tabIndex,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class CommunityError extends CommunityState {
  final String message;
  const CommunityError(this.message);

  @override
  List<Object?> get props => [message];
}
