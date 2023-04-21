import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../utils/helpers.dart';
import '../models/players.dart';

class PlayerRepository {
  ApiConfig apiConfig = ApiConfig.fromEnv();

  Future<List<Player>> get() async {
    final response = await http.get(
      apiConfig.getUrl("players"),
      headers: apiConfig.getHeaders(),
    );

    checkReponseStatusCode(response, 200);

    List<dynamic> players = jsonDecode(response.body);
    List<Player> playersList = players.map((player) {
      return Player.fromJson(player);
    }).toList();
    return playersList;
  }
}
