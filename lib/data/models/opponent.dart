class Opponent {
  final String name;

  Opponent({required this.name});

  Opponent.fromJson(Map<String, dynamic> json) : name = json['name'];

  @override
  String toString() {
    return 'Opponent(name: $name)';
  }
}
