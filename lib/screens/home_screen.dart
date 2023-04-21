import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dotenv.env['TEAM_NAME']!,
                style: const TextStyle(fontSize: 50)),
            Text(
              currentSeason(),
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/club_logo.png',
              width: 200, // Set the width of the image
              height: 200, // Set the height of the image
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/matches');
              },
              child: const Text('Matches'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/top-goals');
              },
              child: const Text('Goals'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/top-assists');
              },
              child: const Text('Assists'),
            )
          ],
        ),
      ),
    );
  }
}
