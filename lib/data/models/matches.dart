import 'package:futsta/data/models/opponent.dart';
import 'package:intl/intl.dart';

class FutsalMatch {
  final DateTime matchDate;
  final Opponent opponent;
  final bool isHome;

  FutsalMatch(
      {required this.matchDate, required this.opponent, required this.isHome});

  factory FutsalMatch.fromJson(Map<String, dynamic> json) {
    final opponentJson = json['opponent'] as Map<String, dynamic>;
    return FutsalMatch(
      matchDate: DateTime.parse(json['match_date']),
      opponent: Opponent.fromJson(opponentJson),
      isHome: json['is_home'],
    );
  }
  @override
  String toString() {
    return 'Match on $matchDate against $opponent)';
  }

  String getReadableDate() {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(matchDate);
  }

  String getAPIDate() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(matchDate);
  }
}
