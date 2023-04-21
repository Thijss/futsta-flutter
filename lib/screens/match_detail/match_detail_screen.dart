import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futsta/data/models/matches.dart';
import 'package:futsta/data/repositories/goals.dart';
import 'package:futsta/screens/add_goal_screen.dart';
import 'package:futsta/screens/match_detail/widgets.dart';
import 'package:futsta/utils/helpers.dart';

import '../../data/models/goals.dart';
import '../../data/models/players.dart';

class MatchDetailScreen extends StatefulWidget {
  final FutsalMatch match;
  final List<Player> players;

  const MatchDetailScreen(
      {super.key, required this.match, required this.players});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final GoalRepository goalRepository = GoalRepository();
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final matchDate = widget.match.getAPIDate();
    try {
      final goals = await goalRepository.getByMatchDate(matchDate);
      setState(() {
        _goals = goals;
      });
    } on HttpException catch (error) {
      showError(error, context);
      setState(() {
        _goals = [];
      });
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, Goal goal) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                try {
                  await GoalRepository().delete(goal);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, true);
                } on HttpException catch (error) {
                  showError(error, context);
                  Navigator.pop(context, false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FutsalMatch match = widget.match;
    final List<Player> players = widget.players;
    final Goal? lastGoal = _goals.isNotEmpty ? _goals.last : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(match.getReadableDate()),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          showTeams(match),
          const SizedBox(height: 16),
          matchScore(lastGoal),
          goalList(match, _goals),
          addGoalbutton(context, match, players),
          const SizedBox(height: 16)
        ],
      ),
    );
  }

  Row showTeams(FutsalMatch match) {
    String homeTeam;
    String awayTeam;
    final String teamName = dotenv.env['TEAM_NAME']!;
    if (match.isHome) {
      homeTeam = teamName;
      awayTeam = match.opponent.name;
    } else {
      homeTeam = match.opponent.name;
      awayTeam = teamName;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 130,
            child: Text(
              homeTeam,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 130,
            child: Text(awayTeam,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Text matchScore(Goal? lastGoal) {
    return Text(
      lastGoal != null ? lastGoal.score.toString() : '0 - 0',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  FloatingActionButton addGoalbutton(
      BuildContext context, FutsalMatch match, List<Player> players) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        final bool? created = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddGoalScreen(
                match: match, players: players, nrGoals: _goals.length),
          ),
        );
        if (created ?? false) {
          await _loadGoals();
        }
      },
    );
  }

  Expanded goalList(FutsalMatch match, List<Goal> goals) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () async {
              bool? confirmed =
                  await _showConfirmationDialog(context, goals[index]);
              if (confirmed!) {
                await _loadGoals();
              }
            },
            child: GoalEvent(goal: _goals[index], isHomeGame: match.isHome),
          );
        },
      ),
    );
  }
}
