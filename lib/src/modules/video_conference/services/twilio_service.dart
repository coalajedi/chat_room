import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/models.dart';

abstract class ITwilioFunctionsService {
  Future<TwilioAccessToken> createToken(String identity);
}

class TwilioFunctionsService implements ITwilioFunctionsService {
  late final http.Client _client;

  TwilioFunctionsService({http.Client? client})
      : _client = client ?? http.Client();

  final accessTokenUrl =
      'https://twiliochatroomaccesstoken-9882.twil.io/accessToken';

  @override
  Future<TwilioAccessToken> createToken(String identity) async {
    try {
      final String roomId = const Uuid().v4();
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse('$accessTokenUrl?user=$identity&room=$roomId');
      final response = await _client.get(url, headers: header);

      final twilioAccessToken = TwilioAccessToken.fromJson(response.body);
      return twilioAccessToken;
    } catch (error) {
      throw Exception([error.toString()]);
    }
  }
}
