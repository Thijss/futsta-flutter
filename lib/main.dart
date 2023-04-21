import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futsta/screens/add_match_screen.dart';
import 'package:futsta/screens/home_Screen.dart';
import 'package:futsta/screens/list_matches_screen.dart';

import 'package:flutter/material.dart';
import 'package:futsta/screens/stats/top_scores_screen.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(222, 11, 110, 155);
    // const Color primaryColor = Color.fromARGB(103, 100, 255, 219);
    return MaterialApp(
      title: 'Futsta',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/matches': (context) => const ListMatchesScreen(),
        '/add-match': (context) => AddMatchScreen(),
        '/top-goals': (context) => const PlayerGoalsScreen(),
        '/top-assists': (context) => const PlayerAssistsScreen(),
      },
      theme: ThemeData.dark().copyWith(
          primaryColor: primaryColor,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: primaryColor,
            // foregroundColor: goodGreen,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
          ),
          appBarTheme: const AppBarTheme(backgroundColor: primaryColor)
          // other properties
          ),
    );
  }
}
