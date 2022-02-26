import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _host = 'http://192.168.57.80:8080';

Future<List<User>> fetchUsers(http.Client client) async {
  final response = await client
      .get(Uri.parse('$_host/user/getAll'));

  return compute(parseUsers, response.body);
}

Future<http.Response> deleteUser(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('$_host/user/delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response;
}

List<User> parseUsers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final int moneyBalance;
  final int personalCardId;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.moneyBalance,
    required this.personalCardId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        birthDate: json['birthDate'] as String,
        moneyBalance: json['moneyBalance'] as int,
        personalCardId: json['personalCardID'] as int
    );
  }
}