import 'package:neoflex_booking/data/data_sources/uth_data_source.dart';
import 'package:neoflex_booking/domain/entities/user.dart';
import 'package:neoflex_booking/domain/repositories/uth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login(String username, String password) async {
    return await dataSource.login(username, password);
  }
}
