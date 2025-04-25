import 'package:flutter/material.dart';
import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/meeting_room.dart';
import 'package:neoflex_booking/domain/models/workspace.dart';
import 'package:neoflex_booking/domain/models/workspace_type.dart';
import 'package:neoflex_booking/presentation/markers/meeting_room_marker.dart';
import 'package:neoflex_booking/presentation/markers/workplace_marker.dart';

class FloorMap extends StatelessWidget {
  final List<BookableSpace> spaces;
  final Function(BookableSpace) onSpaceSelected;
  final TransformationController? transformationController;
  final bool showLegend;
  final String? backgroundImage;
  final BoxFit backgroundFit;
  final Size mapSize;

  const FloorMap({
    super.key,
    required this.spaces,
    required this.onSpaceSelected,
    this.transformationController,
    this.showLegend = true,
    this.backgroundImage,
    this.backgroundFit = BoxFit.contain,
    this.mapSize = const Size(800, 600),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          transformationController: transformationController,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Stack(
            children: [
              if (backgroundImage != null)
                SizedBox(
                  width: mapSize.width,
                  height: mapSize.height,
                  child: Image.asset(
                    backgroundImage!,
                    fit: backgroundFit,
                  ),
                ),
              SizedBox(
                width: mapSize.width,
                height: mapSize.height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: spaces
                      .map((space) => Positioned(
                            left: space.x.clamp(0, mapSize.width - space.width),
                            top:
                                space.y.clamp(0, mapSize.height - space.height),
                            child: SizedBox(
                              width: space.width,
                              height: space.height,
                              child: Transform.rotate(
                                angle: space.rotation,
                                child: GestureDetector(
                                  onTap: () => onSpaceSelected(space),
                                  child: BookableSpaceWidget(space: space),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        if (showLegend)
          Positioned(
            right: 16,
            top: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MapLegend(),
              ),
            ),
          ),
      ],
    );
  }
}

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Условные обозначения:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildLegendItem(
          'Переговорная комната',
          MeetingRoomMarker(
            booked: false,
            capacity: 8,
            hasVideoConference: true,
            hasWhiteboard: true,
            size: 24,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        _buildLegendItem(
          WorkspaceType.noComputer.displayName,
          WorkPlaceMarker(
            booked: false,
            type: WorkspaceType.noComputer,
            size: 24,
            color: const Color(0xFF009688),
            deskNumber: 1,
          ),
        ),
        const SizedBox(height: 4),
        _buildLegendItem(
          WorkspaceType.withMonitor.displayName,
          WorkPlaceMarker(
            booked: false,
            type: WorkspaceType.withMonitor,
            size: 24,
            color: const Color(0xFFFFA000),
            deskNumber: 2,
          ),
        ),
        const SizedBox(height: 4),
        _buildLegendItem(
          WorkspaceType.withOneMonitor.displayName,
          WorkPlaceMarker(
            booked: false,
            type: WorkspaceType.withOneMonitor,
            size: 24,
            color: const Color(0xFF1976D2),
            deskNumber: 3,
          ),
        ),
        const SizedBox(height: 4),
        _buildLegendItem(
          WorkspaceType.withDualMonitor.displayName,
          WorkPlaceMarker(
            booked: false,
            type: WorkspaceType.withDualMonitor,
            size: 24,
            color: const Color(0xFF303F9F),
            deskNumber: 4,
          ),
        ),
        const Divider(),
        _buildLegendItem(
          'Занято',
          WorkPlaceMarker(
            booked: true,
            type: WorkspaceType.noComputer,
            size: 24,
            color: const Color(0xFF009688),
            deskNumber: 0,
          ),
        ),
        const SizedBox(height: 4),
        _buildLegendItem(
          'Доступно',
          WorkPlaceMarker(
            booked: false,
            type: WorkspaceType.noComputer,
            size: 24,
            color: const Color(0xFF009688),
            deskNumber: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Widget marker) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Center(child: marker),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class BookableSpaceWidget extends StatelessWidget {
  final BookableSpace space;

  static final Map<WorkspaceType, Color> _workspaceColors = {
    WorkspaceType.noComputer: const Color(0xFF009688), // Teal 500
    WorkspaceType.withMonitor: const Color(0xFFFFA000), // Amber 700
    WorkspaceType.withOneMonitor: const Color(0xFF1976D2), // Blue 700
    WorkspaceType.withDualMonitor: const Color(0xFF303F9F), // Indigo 700
  };

  const BookableSpaceWidget({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    if (space is MeetingRoom) {
      final meetingRoom = space as MeetingRoom;
      return Center(
        child: MeetingRoomMarker(
          booked: !meetingRoom.isAvailable,
          capacity: meetingRoom.capacity,
          hasVideoConference: meetingRoom.hasVideoConference,
          hasWhiteboard: meetingRoom.hasWhiteboard,
          size: 40,
          color: Colors.blue,
        ),
      );
    } else if (space is Workspace) {
      final workspace = space as Workspace;
      return Center(
        child: WorkPlaceMarker(
          booked: !workspace.isAvailable,
          type: workspace.type,
          size: 35,
          color: _workspaceColors[workspace.type]!,
          deskNumber: workspace.deskNumber,
        ),
      );
    }

    return Container(
      width: space.width,
      height: space.height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        border: Border.all(
          color: space.isAvailable ? Colors.green : Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          space.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
