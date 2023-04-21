import 'package:flutter/material.dart';
import 'package:futsta/screens/select_player_screen.dart';
import 'package:futsta/utils/helpers.dart';

import '../data/models/matches.dart';
import '../data/models/players.dart';
import '../data/repositories/goals.dart';

class AddGoalScreen extends StatefulWidget {
  final List<Player> players;
  final FutsalMatch match;
  final int nrGoals;
  const AddGoalScreen(
      {Key? key,
      required this.players,
      required this.match,
      required this.nrGoals})
      : super(key: key);

  @override
  AddGoalScreenState createState() => AddGoalScreenState();
}

class AddGoalScreenState extends State<AddGoalScreen> {
  static Player defaultPlayer = Player("Select player");
  final GoalRepository goalRepository = GoalRepository();
  Player? _scoredBy = Player("Select player");
  Player? _assistedBy;

  Future<void> setScoredBy(Player? player) async {
    setState(() {
      _scoredBy = player;
    });
  }

  Future<void> setAssistedBy(Player? player) async {
    setState(() {
      _assistedBy = player;
    });
  }

  @override
  Widget build(BuildContext context) {
    String nextOrdinalGoal = toOrdinal(widget.nrGoals + 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add goal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Who scored the $nextOrdinalGoal goal?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            _playerButton(setScoredBy, _scoredBy),
            const SizedBox(height: 16),
            _opponentButton(setScoredBy, _scoredBy, "Opponent", Colors.red),
            const SizedBox(height: 32),
            const Text(
              'Who assisted the goal?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            _playerButton(setAssistedBy, _assistedBy),
            const SizedBox(height: 16),
            _opponentButton(
                setAssistedBy, _assistedBy, "No assist", Colors.blueGrey),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () async {
                if (_scoredBy == defaultPlayer) {
                  showError(
                      Exception("Please select a player or select 'Opponnent'"),
                      context);
                  return;
                }
                try {
                  await goalRepository.add(
                      match: widget.match,
                      scoredBy: _scoredBy,
                      assistedBy: _assistedBy);
                } on Exception catch (error) {
                  showError(error, context);
                  return;
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "SAVE",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opponentButton(Future<void> Function(Player?) selectPlayer,
      Player? currentSelectedPlayer, String buttonText, Color selectionColor) {
    final isSelected = currentSelectedPlayer == null;
    return ElevatedButton(
      onPressed: () {
        selectPlayer(null);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? selectionColor : Colors.grey,
        ),
      ),
      child: Text(buttonText),
    );
  }

  Widget _playerButton(Future<void> Function(Player?) selectPlayer,
      Player? currentSelectedPlayer) {
    final isSelected = currentSelectedPlayer == defaultPlayer ||
        widget.players.contains(currentSelectedPlayer);

    return ElevatedButton(
      onPressed: () async {
        final Player? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPlayerScreen(players: widget.players),
          ),
        );
        selectPlayer(result);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Colors.green : Colors.grey,
        ),
      ),
      child: Text(currentSelectedPlayer?.name ?? "Select player"),
    );
  }
}
