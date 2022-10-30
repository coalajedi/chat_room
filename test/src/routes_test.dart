import 'package:chat_room/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Given the [RouteSettings]', () {
    late RouteSettings settings;
    setUp(() {
      settings = const RouteSettings();
    });

    test('should return the [HomePage]', () {
      settings = settings.copyWith(name: routeHome);

      final route = onGenerateRoute(settings);

      const actual = true;
      final matcher = route.settings.name == routeHome;

      expect(actual, matcher);
    });

    test('should return the [RouteNotFoundPage]', () {
      settings = settings.copyWith(name: 'foo-bar');

      final route = onGenerateRoute(settings);

      const actual = true;
      final matcher = route.settings.name == routeNotfound;

      expect(actual, matcher);
    });

    test('should return the [VideoConferenceManager]', () {
      settings = settings.copyWith(name: routePrefixVideoConference);

      final route = onGenerateRoute(settings);

      const actual = true;
      final matcher =
          route.settings.name!.startsWith(routePrefixVideoConference);

      expect(actual, matcher);
    });

    test('should return the [VideoConferenceManager]', () {
      settings = settings.copyWith(name: routeVideoConferenceJoinRoom);

      final route = onGenerateRoute(settings);

      const actual = true;
      final matcher =
          route.settings.name!.startsWith(routePrefixVideoConference);

      expect(actual, matcher);
    });

    test('should return the [VideoConferenceManager]', () {
      settings = settings.copyWith(name: routeVideoConferenceRoom);

      final route = onGenerateRoute(settings);

      const actual = true;
      final matcher =
          route.settings.name!.startsWith(routePrefixVideoConference);

      expect(actual, matcher);
    });
  });
}
