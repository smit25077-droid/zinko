import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../../../../user/domain/entities/person_entity.dart';
import '../../../domain/usecases/get_workspaces.dart';
import '../../../../community/domain/usecases/person_usecases.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetWorkspaces getWorkspaces;
  final GetPeople getPeople;

  List<WorkspaceEntity> _workspaces = [];
  List<PersonEntity> _people = [];

  MapBloc({required this.getWorkspaces, required this.getPeople})
      : super(const MapState()) {
    on<MapFilterChanged>(_onFilterChanged);
    on<MapDataUpdated>(_onDataUpdated);
    on<GenerateMarkersEvent>(_onGenerateMarkers);
    on<SelectWorkspaceEvent>((event, emit) => emit(state.copyWith(
        selectedWorkspace: event.workspace, clearSelection: false)));
    on<SelectPersonEvent>((event, emit) => emit(
        state.copyWith(selectedPerson: event.person, clearSelection: false)));
    on<ClearSelectionEvent>(
        (event, emit) => emit(state.copyWith(clearSelection: true)));
  }

  Future<void> _onFilterChanged(
      MapFilterChanged event, Emitter<MapState> emit) async {
    emit(state.copyWith(
        selectedFilter: event.filter, isLoading: true, clearSelection: true));
    add(GenerateMarkersEvent(event.filter));
  }

  void _onDataUpdated(MapDataUpdated event, Emitter<MapState> emit) {
    _workspaces = event.workspaces;
    _people = event.people;
    add(GenerateMarkersEvent(state.selectedFilter));
  }

  Future<void> _onGenerateMarkers(
      GenerateMarkersEvent event, Emitter<MapState> emit) async {
    final Set<Marker> newMarkers = {};
    final filter = event.filter;

    // Filter workspaces
    if (filter == 'All' || filter == 'Cafes' || filter == 'Workspaces') {
      for (final workspace in _workspaces) {
        final isCafe = workspace.type == WorkspaceType.cafe;
        if (filter == 'Cafes' && !isCafe) continue;
        if (filter == 'Workspaces' && isCafe) continue;

        try {
          final icon = await _getMarkerIcon(workspace.imageUrl,
              borderColor:
                  isCafe ? const Color(0xFFE53935) : const Color(0xFF43A047));
          newMarkers.add(
            Marker(
              markerId: MarkerId('place_${workspace.id}'),
              position: LatLng(workspace.lat, workspace.lng),
              icon: icon,
              onTap: () => add(SelectWorkspaceEvent(workspace)),
            ),
          );
        } catch (e) {}
      }
    }

    // Filter people
    if (filter == 'All' || filter == 'People') {
      for (final person in _people) {
        try {
          final icon = await _getMarkerIcon(person.avatarUrl,
              borderColor: const Color(0xFF1E88E5));
          newMarkers.add(
            Marker(
              markerId: MarkerId('person_${person.id}'),
              position: LatLng(person.lat, person.lng),
              icon: icon,
              onTap: () => add(SelectPersonEvent(person)),
            ),
          );
        } catch (e) {}
      }
    }

    emit(state.copyWith(markers: newMarkers, isLoading: false));
  }

  Future<BitmapDescriptor> _getMarkerIcon(String url,
      {required Color borderColor}) async {
    const double size = 60.0;
    const double border = 4.5;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = borderColor;
    const Radius radius = Radius.circular(size / 2);

    canvas.drawCircle(
        const Offset(size / 2, size / 2),
        size / 2,
        Paint()
          ..color = Colors.black.withAlpha(40)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 0));
    canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(0.0, 0.0, size, size),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius),
        paint);
    canvas.drawCircle(const Offset(size / 2, size / 2), (size / 2) - border,
        Paint()..color = Colors.white);

    try {
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final ui.Codec codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
          targetWidth: (size - border * 4).toInt(),
          targetHeight: (size - border * 4).toInt());
      final ui.FrameInfo fi = await codec.getNextFrame();
      canvas.save();
      canvas.clipPath(Path()
        ..addOval(Rect.fromLTWH(
            border * 2, border * 2, size - border * 4, size - border * 4)));
      canvas.drawImage(fi.image, const Offset(border * 2, border * 2), Paint());
      canvas.restore();
    } catch (e) {}

    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
