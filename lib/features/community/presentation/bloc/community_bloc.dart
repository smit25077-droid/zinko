import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/community/domain/entities/community_entities.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/usecases/post_usecases.dart';
import 'package:zinko_app/features/community/domain/usecases/group_usecases.dart';
import 'package:zinko_app/features/community/domain/usecases/person_usecases.dart';
import 'package:zinko_app/features/community/presentation/bloc/community_event.dart';
import 'package:zinko_app/features/community/presentation/bloc/community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetPosts getPosts;
  final ToggleLikePost toggleLikePost;
  final GetGroups getGroups;
  final ToggleJoinGroup toggleJoinGroup;
  final GetPeople getPeople;
  final ToggleConnection toggleConnection;

  CommunityBloc({
    required this.getPosts,
    required this.toggleLikePost,
    required this.getGroups,
    required this.toggleJoinGroup,
    required this.getPeople,
    required this.toggleConnection,
  }) : super(CommunityInitial()) {
    on<GetCommunityDataEvent>(_onGetCommunityData);
    on<ToggleLikePostEvent>(_onToggleLikePost);
    on<ToggleJoinGroupEvent>(_onToggleJoinGroup);
    on<ToggleConnectionEvent>(_onToggleConnection);
    on<CommunityTabChangedEvent>(_onTabChanged);
  }

  Future<void> _onGetCommunityData(
      GetCommunityDataEvent event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());

    try {
      // Execute all data fetches in parallel
      final results = await Future.wait([
        getPosts(NoParams()),
        getGroups(NoParams()),
        getPeople(NoParams()),
      ]);

      final postsResult = results[0];
      final groupsResult = results[1];
      final peopleResult = results[2];

      // Check for any failures
      if (postsResult.isLeft()) {
        emit(CommunityError(postsResult.fold((f) => f.message, (_) => '')));
        return;
      }
      if (groupsResult.isLeft()) {
        emit(CommunityError(groupsResult.fold((f) => f.message, (_) => '')));
        return;
      }
      if (peopleResult.isLeft()) {
        emit(CommunityError(peopleResult.fold((f) => f.message, (_) => '')));
        return;
      }

      // Extract successful results
      final posts =
          postsResult.fold((_) => <PostEntity>[], (p) => p as List<PostEntity>);
      final groups = groupsResult.fold(
          (_) => <GroupEntity>[], (g) => g as List<GroupEntity>);
      final people = peopleResult.fold(
          (_) => <PersonEntity>[], (p) => p as List<PersonEntity>);

      emit(CommunityDataLoaded(posts: posts, groups: groups, people: people));
    } catch (e) {
      emit(CommunityError('Failed to load community data: $e'));
    }
  }

  void _onTabChanged(
      CommunityTabChangedEvent event, Emitter<CommunityState> emit) {
    if (state is CommunityDataLoaded) {
      emit((state as CommunityDataLoaded).copyWith(tabIndex: event.index));
    }
  }

  Future<void> _onToggleLikePost(
      ToggleLikePostEvent event, Emitter<CommunityState> emit) async {
    if (state is CommunityDataLoaded) {
      final currentState = state as CommunityDataLoaded;
      final result = await toggleLikePost(event.id);

      result.fold(
        (failure) => emit(CommunityError(failure.message)),
        (updatedPost) {
          final updatedPosts = currentState.posts
              .map((p) => p.id == updatedPost.id ? updatedPost : p)
              .toList();
          emit(currentState.copyWith(posts: updatedPosts));
        },
      );
    }
  }

  Future<void> _onToggleJoinGroup(
      ToggleJoinGroupEvent event, Emitter<CommunityState> emit) async {
    if (state is CommunityDataLoaded) {
      final currentState = state as CommunityDataLoaded;
      final result = await toggleJoinGroup(event.id);

      result.fold(
        (failure) => emit(CommunityError(failure.message)),
        (updatedGroup) {
          final updatedGroups = currentState.groups
              .map((g) => g.id == updatedGroup.id ? updatedGroup : g)
              .toList();
          emit(currentState.copyWith(groups: updatedGroups));
        },
      );
    }
  }

  Future<void> _onToggleConnection(
      ToggleConnectionEvent event, Emitter<CommunityState> emit) async {
    if (state is CommunityDataLoaded) {
      final currentState = state as CommunityDataLoaded;
      final result = await toggleConnection(event.id);

      result.fold(
        (failure) => emit(CommunityError(failure.message)),
        (updatedPerson) {
          final updatedPeople = currentState.people
              .map((p) => p.id == updatedPerson.id ? updatedPerson : p)
              .toList();
          emit(currentState.copyWith(people: updatedPeople));
        },
      );
    }
  }
}
