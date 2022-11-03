import 'package:chat_room/src/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const appBarTitle = 'Home Page';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            child: const Text('Join in a video conference'),
            onPressed: () =>
                Navigator.of(context).pushNamed(routeVideoConferenceStart),
          ),
        ),
      ),
    );
  }
}
