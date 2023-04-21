import 'package:futsta/data/models/players.dart';

enum StatType {
  goals,
  assists,
}

class PlayerStat {
  final Player player;
  final int stat;

  const PlayerStat({required this.player, required this.stat});

  factory PlayerStat.fromJson(Map<String, dynamic> json) {
    return PlayerStat(
      player: Player.fromJson(json['player']),
      stat: json['count'],
    );
  }
}
