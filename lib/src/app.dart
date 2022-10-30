import 'package:flutter/material.dart';

import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room',
      theme: ThemeData.dark(useMaterial3: true),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
