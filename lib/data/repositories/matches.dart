import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:futsta/data/models/opponent.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../utils/helpers.dart';
import '../models/matches.dart';

class MatchRepository {
  ApiConfig apiConfig = ApiConfig.fromEnv();

  Future<List<FutsalMatch>> get() async {
    final response = await http.get(
      apiConfig.getUrl("matches"),
      headers: apiConfig.getHeaders(),
    );

    checkReponseStatusCode(response, 200);

    List<dynamic> matches = jsonDecode(response.body);
    List<FutsalMatch> matchList = matches.map((match) {
      return FutsalMatch.fromJson(match);
    }).toList();

    return matchList;
  }

  Future<void> add(
      {required Opponent opponent,
      required DateTime date,
      required bool isHome,
      required BuildContext context}) async {
    // Prepare the request body with the selected opponent and date values
    String dateString = date.toString().split(' ')[0];
    dynamic requestBody = {
      'opponent': {"name": opponent.name},
      'match_date': dateString,
      'is_home': isHome
    };

    final response = await http.post(
      apiConfig.getUrl("matches"),
      headers: apiConfig.getHeaders(),
      body: jsonEncode(requestBody),
    );

    checkReponseStatusCode(response, 201);
  }

  Future<void> delete(FutsalMatch match) async {
    final opponent = {'name': match.opponent.name};
    final formatter = DateFormat('yyyy-MM-dd');
    final matchDate = formatter.format(match.matchDate);

    final body = {'match_date': matchDate, 'opponent': opponent};

    final response = await http.delete(
      apiConfig.getUrl("matches"),
      headers: apiConfig.getHeaders(),
      body: jsonEncode(body),
    );

    checkReponseStatusCode(response, 204);
  }
}
