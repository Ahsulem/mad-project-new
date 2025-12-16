import 'package:hive/hive.dart';

part 'listening_event.g.dart';

@HiveType(typeId: 1)
class ListeningEvent extends HiveObject {
  @HiveField(0)
  final String songTitle;

  @HiveField(1)
  final DateTime timestamp;

  ListeningEvent({required this.songTitle, required this.timestamp});
}
