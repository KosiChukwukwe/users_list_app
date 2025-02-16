import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:technical_assessment/l10n/l10n.dart';
import 'package:technical_assessment/src/features/users/users.dart';


part 'user_data_source.g.dart';

String baseUrl = "https://jsonplaceholder.typicode.com/users";

@Riverpod(keepAlive: true)
UserDataSource userDataSource(UserDataSourceRef ref) {
  return UserDataSourceImpl();
}

abstract class UserDataSource {
  Future<List<User>> getUsers(BuildContext context);
}

class UserDataSourceImpl implements UserDataSource {

  UserDataSourceImpl();

  @override
  Future<List<User>> getUsers(BuildContext context) async {
    final localizations = context.l10n;

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw HttpException("${localizations.serverError} ${response.statusCode}");
      }
    } on SocketException {
      throw Exception(localizations.noInternet);
    } on HttpException catch (e) {
      throw Exception(e.message);
    } on FormatException {
      throw Exception(localizations.invalidFormat);
    } catch (e) {
      throw Exception("${localizations.unexpectedError} $e");
    }
  }
  }
