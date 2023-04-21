import 'package:flutter/material.dart';

import '../../data/models/goals.dart';

class GoalEvent extends StatelessWidget {
  final Goal goal;
  final bool isHomeGame;

  const GoalEvent({super.key, required this.goal, required this.isHomeGame});

  @override
  Widget build(BuildContext context) {
    bool isHomeGoal;
    if ((isHomeGame && goal.isTeamGoal) || (!isHomeGame && !goal.isTeamGoal)) {
      isHomeGoal = true;
    } else {
      isHomeGoal = false;
    }

    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            isHomeGoal ? HomeSideGoal(goal: goal) : AwaySideGoal(goal: goal),
            // ScoreTile(score: goal.score),
            // OpponentGoal(goal: goal, hidden: goal.isTeamGoal),
          ],
        ),
      ),
    );
  }
}

class HomeSideGoal extends StatelessWidget {
  final Goal goal;

  const HomeSideGoal({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        horizontalTitleGap: -8,
        leading: const Text(
          '⚽',
        ),
        title: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                  text: '${goal.scoredBy?.name ?? ''} ',
                  style: const TextStyle(color: Colors.white)),
              homeScore(goal.score.home, goal.score.away),
            ],
          ),
        ),
        subtitle: Text(
          goal.assistedBy != null ? 'assisted by ${goal.assistedBy!.name}' : '',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class AwaySideGoal extends StatelessWidget {
  final Goal goal;

  const AwaySideGoal({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        trailing: const Text('⚽'),
        title: RichText(
          textAlign: TextAlign.right,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${goal.scoredBy?.name ?? ''} ',
                style: const TextStyle(color: Colors.white),
              ),
              awayScore(goal.score.home, goal.score.away),
            ],
          ),
        ),
        subtitle: Text(
          goal.assistedBy != null ? 'assisted by ${goal.assistedBy!.name}' : '',
          style: const TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

TextSpan homeScore(int home, int away) {
  return TextSpan(
    style: const TextStyle(color: Colors.white),
    children: [
      const TextSpan(text: '('),
      TextSpan(
        text: '$home',
        style: const TextStyle(
          color: Colors.green,
        ),
      ),
      const TextSpan(text: ' - '),
      TextSpan(text: '$away'),
      const TextSpan(text: ')'),
    ],
  );
}

TextSpan awayScore(int home, int away) {
  return TextSpan(
    style: const TextStyle(color: Colors.white),
    children: [
      const TextSpan(
        text: '(',
      ),
      TextSpan(
        text: '$home',
      ),
      const TextSpan(
        text: ' - ',
      ),
      TextSpan(
        text: '$away',
        style: const TextStyle(
          color: Colors.green,
        ),
      ),
      const TextSpan(
        text: ')',
      ),
    ],
  );
}
