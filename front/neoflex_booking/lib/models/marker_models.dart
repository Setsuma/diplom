class MarkerResponse {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  MarkerResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory MarkerResponse.fromJson(Map<String, dynamic> json) {
    return MarkerResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class MarkerRequest {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  MarkerRequest({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
