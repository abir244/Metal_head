import 'package:equatable/equatable.dart';

class PlayerProfileState extends Equatable {
  final bool loading;
  final String name;
  final String position;
  final String avatarUrl;
  final int matches;
  final int goals;
  final int assists;

  const PlayerProfileState({
    this.loading = false,
    this.name = '',
    this.position = '',
    this.avatarUrl = '',
    this.matches = 0,
    this.goals = 0,
    this.assists = 0,
  });

  PlayerProfileState copyWith({
    bool? loading,
    String? name,
    String? position,
    String? avatarUrl,
    int? matches,
    int? goals,
    int? assists,
  }) {
    return PlayerProfileState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      position: position ?? this.position,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      matches: matches ?? this.matches,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
    );
  }

  @override
  List<Object?> get props =>
      [loading, name, position, avatarUrl, matches, goals, assists];
}
