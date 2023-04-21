import 'package:flutter/material.dart';
import 'package:futsta/screens/match_detail/match_detail_screen.dart';

import '../data/models/matches.dart';
import '../data/models/players.dart';
import '../data/repositories/matches.dart';
import '../data/repositories/players.dart';
import '../utils/helpers.dart';
import 'add_match_screen.dart';

class ListMatchesScreen extends StatefulWidget {
  const ListMatchesScreen({Key? key}) : super(key: key);

  @override
  ListMatchesScreenState createState() => ListMatchesScreenState();
}

class ListMatchesScreenState extends State<ListMatchesScreen> {
  final MatchRepository matchRepository = MatchRepository();
  final PlayerRepository playerRepository = PlayerRepository();

  List<FutsalMatch> _matches = [];
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _loadMatches();
    _loadPlayers();
  }

  Future<void> _loadMatches() async {
    try {
      final matches = await matchRepository.get();
      setState(() {
        _matches = matches;
      });
    } on Exception catch (error) {
      showError(error, context);
      setState(() {
        _matches = [];
      });
    }
  }

  Future<void> _loadPlayers() async {
    try {
      final players = await playerRepository.get();
      setState(() {
        _players = players;
      });
    } on Exception catch (error) {
      showError(error, context);
      setState(() {
        _players = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMatches,
        child: ListView.builder(
          itemCount: _matches.length,
          itemBuilder: (context, index) {
            final match = _matches[index];
            return MatchTile(
              match: match,
              formattedDate: match.getReadableDate(),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MatchDetailScreen(match: match, players: _players),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor:
        // const Color.fromARGB(103, 100, 255, 219), // sets background color

        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMatchScreen()),
          );
          if (result == true) {
            await _loadMatches();
          }
        },
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  const MatchTile({
    Key? key,
    required this.match,
    required this.formattedDate,
    required this.onTap,
  }) : super(key: key);

  final FutsalMatch match;
  final String formattedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // trailing: const Text(
      //   "W",
      //   style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      // ),
      onTap: onTap,
      // leading: const Icon(Icons.sports_soccer, size: 40.0),
      title: Text(
        match.opponent.name,
        style: const TextStyle(fontSize: 20.0),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
