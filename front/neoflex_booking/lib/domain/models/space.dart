import 'package:uuid/uuid.dart';

enum SpaceType {
  workspace,
  meetingRoom,
}

class Space {
  final String id;
  final SpaceType spaceType;
  final int floorNumber;
  final double positionX;
  final double positionY;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Space({
    required this.id,
    required this.spaceType,
    required this.floorNumber,
    required this.positionX,
    required this.positionY,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'space_type': spaceType.name,
        'floor_number': floorNumber,
        'position_x': positionX,
        'position_y': positionY,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Space.fromJson(Map<String, dynamic> json) => Space(
        id: json['id'],
        spaceType: SpaceType.values.firstWhere(
          (e) => e.name == json['space_type'],
        ),
        floorNumber: json['floor_number'],
        positionX: json['position_x'],
        positionY: json['position_y'],
        isActive: json['is_active'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}
