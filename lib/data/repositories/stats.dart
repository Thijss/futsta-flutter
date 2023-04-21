import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:futsta/data/models/stats.dart';
import 'package:futsta/utils/helpers.dart';

class StatsRepository {
  ApiConfig apiConfig = ApiConfig.fromEnv();

  Future<List<PlayerStat>> getTopGoals() async {
    return _getPlayerStats("top_goals");
  }

  Future<List<PlayerStat>> getTopAssists() async {
    return _getPlayerStats("top_assists");
  }

  Future<List<PlayerStat>> _getPlayerStats(String subUrl) async {
    final response = await http.get(
      apiConfig.getUrl("stats/$subUrl"),
      headers: apiConfig.getHeaders(),
    );

    checkReponseStatusCode(response, 200);

    List<dynamic> playerStatsJson = jsonDecode(response.body);

    List<PlayerStat> playerStats = playerStatsJson.map((stat) {
      return PlayerStat.fromJson(stat);
    }).toList();
    return playerStats;
  }
}
