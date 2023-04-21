import 'package:flutter/material.dart';
import 'package:futsta/data/models/stats.dart';

class PlayerStatsWidget extends StatelessWidget {
  final String title;
  final StatType statType;
  final List<PlayerStat> playerStats;

  const PlayerStatsWidget({
    super.key,
    required this.playerStats,
    required this.title,
    required this.statType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: playerStats.length,
        itemBuilder: (BuildContext context, int index) {
          final playerStat = playerStats[index];

          Color backgroundColor;
          backgroundColor = index == 0
              ? Colors.amber
              : index == 1
                  ? const Color.fromARGB(255, 180, 180, 180)
                  : index == 2
                      ? Colors.brown
                      : Colors.grey[100]!;

          return Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: ListTile(
              title: Text('${index + 1}. ${playerStat.player.name}',
                  style: const TextStyle(color: Colors.black)),
              trailing: Text('${playerStat.stat} ${statType.name}',
                  style: const TextStyle(color: Colors.black)),
            ),
          );
        },
      ),
    );
  }
}
