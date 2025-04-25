import 'package:neoflex_booking/domain/entities/user.dart';
import 'package:neoflex_booking/domain/models/marker.dart';
import 'package:neoflex_booking/domain/models/booking.dart';

class AuthDataSource {
  final _mockUser = User(id: 'test', username: 'test');
  final _mockMarkers = [
    Marker(
      id: '1',
      officeId: 'office1',
      title: 'Рабочее место 1',
      description: 'Стандартное рабочее место',
      x: 100,
      y: 100,
      type: 'workplace',
    ),
    Marker(
      id: '2',
      officeId: 'office1',
      title: 'Переговорная 1',
      description: 'Комната для встреч',
      x: 200,
      y: 200,
      type: 'meeting_room',
    ),
  ];

  Future<User> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'test' && password == 'test') {
      return _mockUser;
    }
    throw 'Неверное имя пользователя или пароль';
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<Marker>> getMarkers({required String officeId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMarkers.where((marker) => marker.officeId == officeId).toList();
  }

  Future<Marker> createMarker({
    required String officeId,
    required String title,
    required String description,
    required double x,
    required double y,
    required String type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newMarker = Marker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      officeId: officeId,
      title: title,
      description: description,
      x: x,
      y: y,
      type: type,
    );
    _mockMarkers.add(newMarker);
    return newMarker;
  }
}
