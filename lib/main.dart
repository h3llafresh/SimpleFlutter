// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_app/user.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

HomePage homePage = const HomePage(title: "Users",);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Startup Name Generator",
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: homePage);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: const UsersList());
  }
}

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: fetchUsers(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          if (users.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: users.length * 2 - 1,
              itemBuilder: (context, i) {
                if (i.isOdd) return const Divider();
                final index = i ~/ 2;
                final user = users[index];

                return ListTile(
                  title: Text(
                    user.firstName + ' ' + user.lastName,
                    style: _biggerFont,
                  ),
                  onTap: () {
                    _pushUser(context, user);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No users data"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _pushUser(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("User details"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteUser(user.id);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    tooltip: "Delete user",
                  )
                ],
              ),
              body: Center(
                child: Text(
                  'Details of ${user.firstName} ${user.lastName}:\n\nBirth Date: ${user.birthDate}\n\nMoney Balance: ${user.moneyBalance}',
                  style: _biggerFont,
                ),
              ));
        },
      ), // ...to here.
    );
  }
}
