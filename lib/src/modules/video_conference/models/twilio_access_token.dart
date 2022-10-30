import 'dart:convert';

import 'package:equatable/equatable.dart';

class TwilioAccessToken extends Equatable {
  final String accessToken;
  final String userIdentity;
  final String roomId;

  const TwilioAccessToken({
    required this.accessToken,
    required this.userIdentity,
    required this.roomId,
  });

  factory TwilioAccessToken.fromMap(Map<String, dynamic> data) =>
      TwilioAccessToken(
        accessToken: data['access_token'],
        userIdentity: data['user_identity'],
        roomId: data['room_id'],
      );

  factory TwilioAccessToken.fromJson(String data) =>
      TwilioAccessToken.fromMap(json.decode(data));

  Map<String, dynamic> toMap() => {
        'access_token': accessToken,
        'user_identity': userIdentity,
        'room_id': roomId,
      };

  String toJson() => jsonEncode(toMap());

  @override
  List<Object?> get props => [accessToken, userIdentity, roomId];
}
