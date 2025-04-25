import 'package:neoflex_booking/domain/entities/user.dart';
import 'package:neoflex_booking/domain/repositories/uth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
