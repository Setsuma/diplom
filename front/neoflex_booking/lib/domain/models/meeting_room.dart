import 'space.dart';

class MeetingRoom extends Space {
  final String name;
  final int capacity;
  final bool hasVideoConference;
  final bool hasWhiteboard;
  final bool isAvailable;

  const MeetingRoom({
    required super.id,
    required this.name,
    required this.capacity,
    required this.hasVideoConference,
    required this.hasWhiteboard,
    required super.floorNumber,
    required super.positionX,
    required super.positionY,
    this.isAvailable = true,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
  }) : super(spaceType: SpaceType.meetingRoom);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'name': name,
        'capacity': capacity,
        'has_video_conference': hasVideoConference,
        'has_whiteboard': hasWhiteboard,
        'is_available': isAvailable,
      };

  factory MeetingRoom.fromJson(Map<String, dynamic> json) => MeetingRoom(
        id: json['id'],
        name: json['name'],
        capacity: json['capacity'],
        hasVideoConference: json['has_video_conference'],
        hasWhiteboard: json['has_whiteboard'],
        floorNumber: json['floor_number'],
        positionX: json['position_x'],
        positionY: json['position_y'],
        isAvailable: json['is_available'],
        isActive: json['is_active'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  MeetingRoom copyWith({
    String? id,
    String? name,
    int? capacity,
    bool? hasVideoConference,
    bool? hasWhiteboard,
    int? floorNumber,
    double? positionX,
    double? positionY,
    bool? isAvailable,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeetingRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      hasVideoConference: hasVideoConference ?? this.hasVideoConference,
      hasWhiteboard: hasWhiteboard ?? this.hasWhiteboard,
      floorNumber: floorNumber ?? this.floorNumber,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
