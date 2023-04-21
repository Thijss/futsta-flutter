import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../utils/helpers.dart';
import '../models/opponent.dart';

class OpponentRepository {
  ApiConfig apiConfig = ApiConfig.fromEnv();

  Future<List<Opponent>> get() async {
    final response = await http.get(
      apiConfig.getUrl("opponents"),
      headers: apiConfig.getHeaders(),
    );

    checkReponseStatusCode(response, 200);

    List<dynamic> opponents = jsonDecode(response.body);
    List<Opponent> opponentList = opponents.map((opponent) {
      return Opponent.fromJson(opponent);
    }).toList();
    return opponentList;
  }
}
