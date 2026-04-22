import 'dart:async';
import 'package:zinko_app/features/booking/data/models/workspace_model.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';

abstract class WorkspaceLocalDataSource {
  Future<List<WorkspaceEntity>> getWorkspaces();
  Stream<List<WorkspaceEntity>> watchWorkspaces();
  Future<void> toggleFavorite(String id);
  Future<void> toggleBookmark(String id);
}

class WorkspaceLocalDataSourceImpl implements WorkspaceLocalDataSource {
  final List<WorkspaceEntity> _workspaces = [];
  final _controller = StreamController<List<WorkspaceEntity>>.broadcast();

  @override
  Stream<List<WorkspaceEntity>> watchWorkspaces() => _controller.stream;

  @override
  Future<List<WorkspaceEntity>> getWorkspaces() async {
    return _workspaces;
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final index = _workspaces.indexWhere((w) => w.id == id);
    if (index != -1) {
      final workspace = _workspaces[index];
      _workspaces[index] = WorkspaceModel.fromEntity(
        WorkspaceEntity(
          id: workspace.id,
          name: workspace.name,
          location: workspace.location,
          price: workspace.price,
          imageUrl: workspace.imageUrl,
          images: workspace.images,
          amenities: workspace.amenities,
          amenityNames: workspace.amenityNames,
          description: workspace.description,
          phone: workspace.phone,
          email: workspace.email,
          tablesLeft: workspace.tablesLeft,
          totalSlots: workspace.totalSlots,
          isFavorite: !workspace.isFavorite,
          lat: workspace.lat,
          lng: workspace.lng,
          reviews: workspace.reviews,
          cafeTimeSlots: workspace.cafeTimeSlots,
          cafeWorkSpaces: workspace.cafeWorkSpaces,
        ),
      );
      _controller.add(List.unmodifiable(_workspaces));
    }
  }

  @override
  Future<void> toggleBookmark(String id) async {
    final index = _workspaces.indexWhere((w) => w.id == id);
    if (index != -1) {
      // final w = _workspaces[index];
      // Since isBookmarked is removed, this method is currently a no-op or should be removed.
      // I will keep it as a no-op for now to avoid breaking the interface if it's used elsewhere.
      _controller.add(List.unmodifiable(_workspaces));
    }
  }
}

