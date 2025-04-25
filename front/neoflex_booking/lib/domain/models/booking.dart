import 'package:json_annotation/json_annotation.dart';
import 'package:neoflex_booking/domain/models/bookable_space.dart';
import 'package:neoflex_booking/domain/models/user_profile.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final String id;
  final String spaceId;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.spaceId,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'space_id': spaceId,
        'user_id': userId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        spaceId: json['space_id'],
        userId: json['user_id'],
        startTime: DateTime.parse(json['start_time']),
        endTime: DateTime.parse(json['end_time']),
        status: BookingStatus.values.firstWhere(
          (e) => e.name == json['status'],
        ),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  bool get isActive => status == BookingStatus.confirmed;

  bool get isPending => status == BookingStatus.pending;

  bool get isCancelled => status == BookingStatus.cancelled;

  bool get isExpired => status == BookingStatus.expired;

  Booking copyWith({
    String? id,
    String? spaceId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
}
