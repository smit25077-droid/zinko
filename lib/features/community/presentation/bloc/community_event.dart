abstract class CommunityEvent {}

class GetCommunityDataEvent extends CommunityEvent {}

class ToggleLikePostEvent extends CommunityEvent {
  final String id;
  ToggleLikePostEvent(this.id);
}

class ToggleJoinGroupEvent extends CommunityEvent {
  final String id;
  ToggleJoinGroupEvent(this.id);
}

class ToggleConnectionEvent extends CommunityEvent {
  final String id;
  ToggleConnectionEvent(this.id);
}

class CommunityTabChangedEvent extends CommunityEvent {
  final int index;
  CommunityTabChangedEvent(this.index);
}
