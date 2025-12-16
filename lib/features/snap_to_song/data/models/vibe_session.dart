import 'package:hive/hive.dart';

part 'vibe_session.g.dart';

@HiveType(typeId: 0)
class VibeSession extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final List<String> detectedLabels;

  @HiveField(2)
  final List<String> suggestedSongs;

  VibeSession({
    required this.timestamp,
    required this.detectedLabels,
    required this.suggestedSongs,
  });

  @override
  String toString() {
    return 'VibeSession(timestamp: $timestamp, labels: $detectedLabels, songs: $suggestedSongs)';
  }
}
