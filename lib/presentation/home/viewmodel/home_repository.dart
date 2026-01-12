
import '../model/match.dart';
import '../model/child_profile.dart';

abstract class HomeRepository {
  Future<ChildProfile> fetchChildProfile();
  Future<List<Match>> fetchUpcomingMatches();
  Future<List<Match>> fetchMatchHistory();
}

class FakeHomeRepository implements HomeRepository {
  @override
  Future<ChildProfile> fetchChildProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ChildProfile.mock();
  }

  @override
  Future<List<Match>> fetchUpcomingMatches() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Match.mockUpcoming();
  }

  @override
  Future<List<Match>> fetchMatchHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Match.mockHistory();
  }
}
