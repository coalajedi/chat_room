import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../shared/pages/route_not_found_page.dart';

part 'room/room_page.dart';
part 'conference/conference_page.dart';

class VideoConferenceManager extends StatefulWidget {
  const VideoConferenceManager({super.key});

  @override
  State<VideoConferenceManager> createState() => _VideoConferenceManagerState();
}

class _VideoConferenceManagerState extends State<VideoConferenceManager> {
  final GlobalKey<NavigatorState> _videoConferenceNavigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => _VideoConferenceManagerView(this);

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeVideoConferenceJoinRoom:
        page = const RoomPage();
        break;
      case routeVideoConferenceRoom:
        page = const ConferecePage();
        break;
      default:
        page = const RouteNotFoundPage();
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) => page,
    );
  }
}

class _VideoConferenceManagerView extends StatelessWidget {
  final _VideoConferenceManagerState _controller;

  const _VideoConferenceManagerView(this._controller);

  VideoConferenceManager get widget => _controller.widget;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _controller._videoConferenceNavigatorKey,
      onGenerateRoute: _controller._onGenerateRoute,
    );
  }
}
