import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/workspace_type.dart';
import 'space.dart';

class Workspace extends Space {
  final int? deskNumber;
  final WorkspaceType workspaceType;
  final bool isAvailable;

  const Workspace({
    required super.id,
    required this.deskNumber,
    required this.workspaceType,
    required super.floorNumber,
    required super.positionX,
    required super.positionY,
    this.isAvailable = true,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
  }) : super(spaceType: SpaceType.workspace);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'desk_number': deskNumber,
        'workspace_type': workspaceType.name,
        'is_available': isAvailable,
      };

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
        id: json['id'],
        deskNumber: json['desk_number'],
        workspaceType: WorkspaceType.values.firstWhere(
          (e) => e.name == json['workspace_type'],
        ),
        floorNumber: json['floor_number'],
        positionX: json['position_x'],
        positionY: json['position_y'],
        isAvailable: json['is_available'],
        isActive: json['is_active'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  @override
  String get displayDescription {
    final buffer = StringBuffer(super.displayDescription);
    buffer.writeln('Тип места: ${workspaceType.displayName}');
    buffer.writeln('Номер стола: $deskNumber');
    buffer.writeln('Сетевое подключение: ${isAvailable ? "Есть" : "Нет"}');
    return buffer.toString();
  }

  Workspace copyWith({
    String? id,
    int? deskNumber,
    WorkspaceType? workspaceType,
    int? floorNumber,
    double? positionX,
    double? positionY,
    bool? isAvailable,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workspace(
      id: id ?? this.id,
      deskNumber: deskNumber ?? this.deskNumber,
      workspaceType: workspaceType ?? this.workspaceType,
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
