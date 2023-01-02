import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
      onPressed: () async {
        await context.read<AuthModel>().logout();
      },
      child: const Text('Logout'),
    )));
  }
}
