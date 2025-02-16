import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:technical_assessment/src/features/users/users.dart';


part 'user_controller.g.dart';

abstract class UserController {
  Future<void> getUsers(BuildContext context);
}

@Riverpod(keepAlive: true)
class UserControllerImpl extends _$UserControllerImpl
    implements UserController {
  @override
  FutureOr<void> build() {}

  List<User> users = [];
  String searchQuery = "";
  List<User>? filteredUsers;
  String? errorMessage;

  @override
  Future<void> getUsers(BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      final userRepo = ref.read(userRepositoryProvider);
      users = await userRepo.getUsers(context);
      errorMessage = null;
      _updateFilteredUsers();
    } catch (e, stackTrace) {
      errorMessage = e.toString().replaceAll("Exception:", "").trim();
      users = [];
      state = AsyncValue.error(errorMessage as String, stackTrace);
    }
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _updateFilteredUsers();
  }

  List<User>? _updateFilteredUsers() {
    if (users.isEmpty) {
      state = const AsyncValue<List<User>>.data([]);
      return [];
    }
    filteredUsers = searchQuery.isEmpty
        ? users
        : users
            .where((user) =>
                user.name!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
    state = AsyncValue<List<User>>.data(filteredUsers!);
    return filteredUsers;
  }
}

