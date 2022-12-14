import 'package:chat_room/src/modules/home/home_page.dart';
import 'package:flutter/material.dart';

import 'modules/video_conference/pages/video_conference_manager.dart';
import 'shared/pages/route_not_found_page.dart';

const String routeHome = '/';
const String routeNotfound = '/not-found';

/// NESTED NAVIGATION IN [video-conference] ROUTE
const String routePrefixVideoConference = '/video-conference/';
const String routeVideoConferenceStart =
    '$routePrefixVideoConference$routeVideoConferenceJoinRoom';
const String routeVideoConferenceJoinRoom = 'join-room';
const String routeVideoConferenceRoom = 'room';

Route onGenerateRoute(RouteSettings settings) {
  late Widget page;
  if (settings.name == routeHome) {
    page = const HomePage();
  } else if (settings.name?.startsWith(routePrefixVideoConference) ?? false) {
    final subRoute =
        settings.name!.substring(routePrefixVideoConference.length);
    page = VideoConferenceManager(subRoute: subRoute);
  } else {
    settings = settings.copyWith(name: routeNotfound);
    page = const RouteNotFoundPage();
  }

  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}
