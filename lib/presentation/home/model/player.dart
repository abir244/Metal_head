class Player {
  final String name;
  final String? imageUrl; // for avatar
  final String? position; // e.g., 'Midfielder'
  final String? teamName; // e.g., 'Real Madrid'

  const Player({
    required this.name,
    this.imageUrl,
    this.position,
    this.teamName,
  });

  // Backwards-compatible getter for older widgets using `image`
  String? get image => imageUrl;

  // mock player for testing
  static Player mock() => const Player(
    name: 'Cristiano Ronaldo',
    imageUrl: 'assets/images/cr7.png',
    position: 'Forward',
    teamName: 'Manchester United',
  );
}
