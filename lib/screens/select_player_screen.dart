import 'package:flutter/material.dart';

import '../data/models/players.dart';

class SelectPlayerScreen extends StatelessWidget {
  final List<Player> players;

  const SelectPlayerScreen({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final player in players)
              _buildPlayerButton(player.name, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerButton(String playerName, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, Player(playerName));
          },
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.all(
          //     Colors.grey,
          //   ),
          // ),
          child: Text(playerName),
        ),
      ),
    );
  }
}
