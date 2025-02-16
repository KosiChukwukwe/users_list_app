import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:technical_assessment/src/features/users/users.dart';


part 'user_data_source.g.dart';

String baseUrl = "https://jsonplaceholder.typicode.com/users";

@Riverpod(keepAlive: true)
UserDataSource userDataSource(UserDataSourceRef ref) {
  return UserDataSourceImpl();
}

abstract class UserDataSource {
  Future<List<User>> getUsers();
}

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl();

  @override
  Future<List<User>> getUsers() async {

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw HttpException("Server error: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on HttpException catch (e) {
      throw Exception(e.message);
    } on FormatException {
      throw Exception("Invalid response format. Please try again later.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
  }
