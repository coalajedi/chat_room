import 'dart:convert';
import 'dart:io';

import 'package:chat_room/src/modules/video_conference/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String getRawData() => File(
          'test/src/modules/video_conference/models/twilio_access_token/raw_data.json')
      .readAsStringSync();

  test(
      'should create a [TwilioAccessToken] instance object from [Map<String, dynamic>]',
      () {
    // arrange
    final String source = getRawData();
    final Map<String, dynamic> mapToCreateObject = json.decode(source);
    final matcher = isA<TwilioAccessToken>();

    // act
    final actual = TwilioAccessToken.fromMap(mapToCreateObject);

    // assert
    expect(actual, matcher);
  });

  test('should create a [TwilioAccessToken] instance object from raw data', () {
    // arrange
    final String source = getRawData();
    final matcher = isA<TwilioAccessToken>();

    // act
    final actual = TwilioAccessToken.fromJson(source);

    // assert
    expect(actual, matcher);
  });

  test(
      'should create a [Map<String, dynamic>] representation of [TwilioAccessToken] class',
      () {
    // arrange
    final String source = getRawData();
    final matcher = json.decode(source);

    // act
    final actual = TwilioAccessToken.fromJson(source).toMap();

    // assert
    expect(actual, matcher);
  });

  test('should create a raw data representation of [TwilioAccessToken] class',
      () {
    // arrange
    final String source = getRawData();
    final matcher = json.encode(json.decode(source));

    // act
    final actual = TwilioAccessToken.fromJson(source).toJson();

    // assert
    expect(actual, matcher);
  });
}
