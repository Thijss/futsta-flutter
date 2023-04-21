import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class ApiConfig {
  final String apiKey;
  final String apiUrl;

  ApiConfig({required this.apiKey, required this.apiUrl});

  factory ApiConfig.fromEnv() {
    final apiKey = dotenv.env['API_KEY']!;
    final apiUrl = dotenv.env['API_URL']!;
    return ApiConfig(apiKey: apiKey, apiUrl: apiUrl);
  }

  Uri getUrl(String path) {
    if (apiUrl.startsWith('localhost')) {
      return Uri.http(apiUrl, path);
    } else {
      return Uri.https(apiUrl, path);
    }
  }

  Map<String, String> getHeaders() {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ApiKey': apiKey,
    };
  }
}

void devPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

void checkReponseStatusCode(Response response, int expectedStatusCode) {
  if (response.statusCode == expectedStatusCode) {
    return;
  } else {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    final detail = jsonResponse['detail'];

    if (detail.runtimeType == List) {
      throw HttpException(detail[0]["msg"]);
    } else {
      throw HttpException(detail);
    }
  }
}

void showError(Exception error, BuildContext context) {
  String errorMessage;
  if (error is HttpException) {
    errorMessage = error.message;
  } else {
    errorMessage = error.toString();
  }

  devPrint(error.toString());
  final snackBar = SnackBar(
    content: Text(errorMessage),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String toOrdinal(int n) {
  if (n % 100 >= 11 && n % 100 <= 13) {
    return '${n}th';
  }
  switch (n % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

String currentSeason() {
  final now = DateTime.now();
  final year = now.year;
  final month = now.month;
  final season = month >= 8 ? year : year - 1;
  return '$season - ${season + 1}';
}
