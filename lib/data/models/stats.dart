import 'package:futsta/data/models/players.dart';

enum StatType {
  goal,
  assist,
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

  String statAsString(StatType statType) {
    String suffix;
    if (stat != 1) {
      suffix = 's';
    } else {
      suffix = '';
    }
    String statOrUnknown = stat != -1 ? stat.toString() : "?";

    return '$statOrUnknown ${statType.name}$suffix';
  }
}
