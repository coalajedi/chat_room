import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../shared/pages/route_not_found_page.dart';
import 'models/models.dart';
import 'services/twilio_service.dart';

part 'conference/conference_page.dart';
part 'room/room_page.dart';

class VideoConferenceManager extends StatefulWidget {
  final String subRoute;
  const VideoConferenceManager({super.key, required this.subRoute});

  @override
  State<VideoConferenceManager> createState() => _VideoConferenceManagerState();
}

class _VideoConferenceManagerState extends State<VideoConferenceManager> {
  final _videoConferenceNavigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => _VideoConferenceManagerView(this);

  void _onSubmitRoomPage(TwilioAccessToken accessToken) {}

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeVideoConferenceJoinRoom:
        page = RoomPage(onSubmit: _onSubmitRoomPage);
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
    return Scaffold(
      body: Navigator(
        key: _controller._videoConferenceNavigatorKey,
        initialRoute: widget.subRoute,
        onGenerateRoute: _controller._onGenerateRoute,
      ),
    );
  }
}
