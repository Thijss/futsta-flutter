import 'package:flutter/material.dart';
import 'package:futsta/data/models/stats.dart';
import 'package:futsta/data/repositories/stats.dart';
import 'package:futsta/utils/helpers.dart';
import 'widgets.dart';

abstract class PlayerStatsState<T extends StatefulWidget> extends State<T> {
  final StatsRepository statsRepository = StatsRepository();

  List<PlayerStat> playerStats = [];

  Future<void> _loadPlayerStats(StatType statType) async {
    Future<List<PlayerStat>> Function() getStats;
    if (statType == StatType.goals) {
      getStats = statsRepository.getTopGoals;
    } else if (statType == StatType.assists) {
      getStats = statsRepository.getTopAssists;
    } else {
      throw Exception('Invalid stat type');
    }

    try {
      final playerStatsFromDb = await getStats();
      setState(() {
        playerStats = playerStatsFromDb;
      });
    } on Exception catch (error) {
      showError(error, context);
      setState(() {
        playerStats = [];
      });
    }
  }
}

class PlayerGoalsScreen extends StatefulWidget {
  const PlayerGoalsScreen({super.key});

  @override
  State<PlayerGoalsScreen> createState() => PlayerGoalsScreenState();
}

class PlayerGoalsScreenState extends PlayerStatsState<PlayerGoalsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlayerStats(StatType.goals);
  }

  @override
  Widget build(BuildContext context) {
    return PlayerStatsWidget(
        playerStats: playerStats,
        title: "Top Scores",
        statType: StatType.goals);
  }
}

class PlayerAssistsScreen extends StatefulWidget {
  const PlayerAssistsScreen({super.key});

  @override
  State<PlayerAssistsScreen> createState() => PlayerAssistsScreenState();
}

class PlayerAssistsScreenState extends PlayerStatsState<PlayerAssistsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlayerStats(StatType.assists);
  }

  @override
  Widget build(BuildContext context) {
    return PlayerStatsWidget(
        playerStats: playerStats,
        title: "Top Assists",
        statType: StatType.assists);
  }
}
