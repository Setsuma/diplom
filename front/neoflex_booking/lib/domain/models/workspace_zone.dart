import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/meeting_room.dart';

class WorkspaceZone {
  final String id;
  final String name;
  final String description;
  final List<BookableSpace> spaces;
  final bool isPreset; // предустановленная зона или пользовательский выбор

  const WorkspaceZone({
    required this.id,
    required this.name,
    required this.description,
    required this.spaces,
    this.isPreset = false,
  });

  bool get isAvailable => spaces.every((space) => space.isAvailable);

  int get totalCapacity {
    int capacity = 0;
    for (var space in spaces) {
      if (space is MeetingRoom) {
        capacity += space.capacity;
      } else {
        capacity += 1; // для рабочего места
      }
    }
    return capacity;
  }

  String get locationDescription {
    final locations = spaces.map((e) => e.location).toSet();
    return locations.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'spaces': spaces.map((e) => e.id).toList(),
      'isPreset': isPreset,
    };
  }
}
