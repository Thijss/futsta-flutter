import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:futsta/data/models/goals.dart';
import 'package:futsta/data/models/matches.dart';
import 'package:futsta/utils/helpers.dart';
import 'package:futsta/data/models/players.dart';

class GoalRepository {
  ApiConfig apiConfig = ApiConfig.fromEnv();

  Future<List<Goal>> getByMatchDate(String matchDate) async {
    final response = await http.get(
      apiConfig.getUrl("goals/$matchDate"),
      headers: apiConfig.getHeaders(),
    );

    checkReponseStatusCode(response, 200);

    List<dynamic> goals = jsonDecode(response.body);
    List<Goal> goalList = goals.map((goal) {
      return Goal.fromJson(goal);
    }).toList();

    return goalList;
  }

  Future<void> add(
      {required FutsalMatch match,
      required Player? scoredBy,
      required Player? assistedBy}) async {
    dynamic requestBody = {
      "match_date": match.getAPIDate(),
      "scored_by": scoredBy?.name,
      "assisted_by": assistedBy?.name
    };
    devPrint(jsonEncode(requestBody));
    final response = await http.post(
      apiConfig.getUrl("goals"),
      headers: apiConfig.getHeaders(),
      body: jsonEncode(requestBody),
    );

    checkReponseStatusCode(response, 201);
  }

  Future<void> delete(Goal goal) async {
    final body = goal.toJson();
    final response = await http.delete(
      apiConfig.getUrl("goals"),
      headers: apiConfig.getHeaders(),
      body: jsonEncode(body),
    );

    checkReponseStatusCode(response, 200);
  }
}
