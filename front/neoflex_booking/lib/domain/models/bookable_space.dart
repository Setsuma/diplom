abstract class BookableSpace {
  final String id;
  final String name;
  final String description;
  final bool isAvailable;
  final Map<String, dynamic> equipment;
  final String location;
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;

  BookableSpace({
    required this.id,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.equipment,
    required this.location,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0,
  });

  String get displayDescription {
    final buffer = StringBuffer();
    buffer.writeln('Название: $name');
    buffer.writeln('Расположение: $location');
    buffer.writeln('Статус: ${isAvailable ? "Доступно" : "Занято"}');
    if (equipment.isNotEmpty) {
      buffer.writeln('Оборудование:');
      equipment.forEach((key, value) => buffer.writeln('- $key: $value'));
    }
    buffer.writeln(description);
    return buffer.toString();
  }
}
