import 'package:futsta/data/models/players.dart';
import 'package:futsta/data/models/scores.dart';

class Goal {
  final DateTime matchDate;
  final Player? scoredBy;
  final Player? assistedBy;
  final bool isTeamGoal;
  final Score score;
  final int order;

  const Goal({
    required this.matchDate,
    this.scoredBy,
    this.assistedBy,
    required this.isTeamGoal,
    required this.score,
    required this.order,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      matchDate: DateTime.parse(json['match_date']),
      scoredBy:
          json['scored_by'] != null ? Player.fromJson(json['scored_by']) : null,
      assistedBy: json['assisted_by'] != null
          ? Player.fromJson(json['assisted_by'])
          : null,
      isTeamGoal: json['is_team_goal'],
      score: Score.fromJson(json['score']),
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() => {
        "match_date": matchDate.toIso8601String().substring(0, 10),
        "scored_by":
            scoredBy != null && scoredBy is Player ? scoredBy!.toJson() : null,
        "assisted_by": assistedBy != null && assistedBy is Player
            ? assistedBy!.toJson()
            : null,
        "score": score.toJson(),
        "is_team_goal": isTeamGoal,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          runtimeType == other.runtimeType &&
          matchDate == other.matchDate &&
          score == other.score;

  @override
  int get hashCode => matchDate.hashCode ^ score.hashCode;
}
