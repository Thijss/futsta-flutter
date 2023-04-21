class Score {
  final int home;
  final int away;

  const Score({
    required this.home,
    required this.away,
  });

  Score.fromJson(Map<String, dynamic> json)
      : home = json['home'],
        away = json['away'];

  Map<String, dynamic> toJson() => {
        "home": home,
        "away": away,
      };

  @override
  String toString() {
    return '$home - $away';
  }
}
