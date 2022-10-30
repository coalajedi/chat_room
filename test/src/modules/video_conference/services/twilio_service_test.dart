import 'dart:convert';

import 'package:chat_room/src/modules/video_conference/models/models.dart';
import 'package:chat_room/src/modules/video_conference/services/twilio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  group('When call [createToken] function', () {
    test('should return an [AccessToken] object', () async {
      // ARRANGE
      const mockCreateTokenResponse = {
        'access_token': 'accessToken',
        'user_identity': 'identity',
        'room_id': 'uuid',
      };

      final mockClient = MockClient((request) async {
        if (request.url.queryParameters.containsKey('user') &&
            request.url.queryParameters.containsKey('room')) {
          return Response(json.encode(mockCreateTokenResponse), 200);
        }
        return Response(json.encode({'error': 'error'}), 400);
      });

      final twilioService = TwilioFunctionsService(client: mockClient);

      // ACT
      final actual = await twilioService.createToken('identity');

      // ASSERT
      final matcher1 = isA<TwilioAccessToken>();
      final matcher2 = TwilioAccessToken.fromMap(mockCreateTokenResponse);

      expect(actual, matcher1);
      expect(actual, matcher2);
    });

    test('should throw an Exception', () async {
      // ARRANGE
      final mockClient = MockClient((request) async {
        return Response(json.encode({'error': 'error'}), 400);
      });

      final twilioService = TwilioFunctionsService(client: mockClient);

      // ACT
      final actual = twilioService.createToken;

      // ASSERT
      final matcher = throwsA(isA<Exception>());

      expectLater(actual('identity'), matcher);
    });
  });
}
