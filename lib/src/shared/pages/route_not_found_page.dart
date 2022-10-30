import 'package:flutter/material.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({super.key});

  PreferredSizeWidget get _appBar => AppBar(
        title: const Text('Unknown Route'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF222222),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.error,
                        size: 175,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Page not found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
