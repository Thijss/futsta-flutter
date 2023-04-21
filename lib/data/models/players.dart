class Player {
  final String name;

  Player(this.name);

  Player.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
