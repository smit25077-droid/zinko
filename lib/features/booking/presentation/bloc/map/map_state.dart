import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../../../user/domain/entities/person_entity.dart';

class MapState extends Equatable {
  final String selectedFilter;
  final Set<Marker> markers;
  final bool isLoading;
  final WorkspaceEntity? selectedWorkspace;
  final PersonEntity? selectedPerson;

  const MapState({
    this.selectedFilter = 'All',
    this.markers = const {},
    this.isLoading = false,
    this.selectedWorkspace,
    this.selectedPerson,
  });

  @override
  List<Object?> get props =>
      [selectedFilter, markers, isLoading, selectedWorkspace, selectedPerson];

  MapState copyWith({
    String? selectedFilter,
    Set<Marker>? markers,
    bool? isLoading,
    WorkspaceEntity? selectedWorkspace,
    PersonEntity? selectedPerson,
    bool clearSelection = false,
  }) {
    return MapState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      selectedWorkspace:
          clearSelection ? null : (selectedWorkspace ?? this.selectedWorkspace),
      selectedPerson:
          clearSelection ? null : (selectedPerson ?? this.selectedPerson),
    );
  }
}
