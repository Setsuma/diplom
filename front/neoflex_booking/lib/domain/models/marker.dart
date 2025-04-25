class Marker {
  final String id;
  final String officeId;
  final String title;
  final String description;
  final double x;
  final double y;
  final String type;
  final bool isBooked;

  Marker({
    required this.id,
    required this.officeId,
    required this.title,
    required this.description,
    required this.x,
    required this.y,
    required this.type,
    this.isBooked = false,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'] as String,
      officeId: json['officeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      type: json['type'] as String,
      isBooked: json['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'officeId': officeId,
      'title': title,
      'description': description,
      'x': x,
      'y': y,
      'type': type,
      'isBooked': isBooked,
    };
  }

  Marker copyWith({
    String? id,
    String? officeId,
    String? title,
    String? description,
    double? x,
    double? y,
    String? type,
    bool? isBooked,
  }) {
    return Marker(
      id: id ?? this.id,
      officeId: officeId ?? this.officeId,
      title: title ?? this.title,
      description: description ?? this.description,
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}
