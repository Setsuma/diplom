import 'package:flutter/material.dart';
import '../../domain/models/bookable_space.dart';
import '../../domain/models/meeting_room.dart';
import '../../domain/models/workspace.dart';
import '../markers/meeting_room_marker.dart';
import '../markers/workplace_marker.dart';

class MapLegend extends StatelessWidget {
  final List<BookableSpace> spaces;

  const MapLegend({
    super.key,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    final meetingRooms = spaces.whereType<MeetingRoom>().toList();
    final workspaces = spaces.whereType<WorkSpace>().toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Легенда',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (meetingRooms.isNotEmpty) ...[
              const Text(
                'Переговорные комнаты:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MeetingRoomMarker(
                    size: 24,
                    booked: false,
                    hasVideoConference: true,
                    hasWhiteboard: true,
                    capacity: 8,
                  ),
                  const SizedBox(width: 8),
                  const Text('Свободная'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MeetingRoomMarker(
                    size: 24,
                    booked: true,
                    hasVideoConference: true,
                    hasWhiteboard: true,
                    capacity: 8,
                  ),
                  const SizedBox(width: 8),
                  const Text('Занятая'),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (workspaces.isNotEmpty) ...[
              const Text(
                'Рабочие места:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WorkSpaceMarker(
                    size: 24,
                    booked: false,
                  ),
                  const SizedBox(width: 8),
                  const Text('Свободное'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WorkSpaceMarker(
                    size: 24,
                    booked: true,
                  ),
                  const SizedBox(width: 8),
                  const Text('Занятое'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
