import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:technical_assessment/src/features/users/users.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final userDataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(userDataSource);
}

abstract class UserRepository {
  Future<List<User>> getUsers(BuildContext context);
}

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl(this.userDataSource);

  @override
  Future<List<User>> getUsers(BuildContext context) async {
    try {
      final users = await userDataSource.getUsers(context);
      return users;
    } catch (e) {
      rethrow;
    }
  }
}
