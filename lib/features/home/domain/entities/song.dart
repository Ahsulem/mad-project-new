class Song {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final String coverUrl;
  final String hexColor;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.coverUrl,
    required this.hexColor,
  });

  factory Song.fromJson(Map<String, dynamic> json, String documentId) {
    return Song(
      id: documentId,
      title: json['title'] as String,
      artist: json['artist'] as String,
      audioUrl: json['audioUrl'] as String,
      coverUrl: json['coverUrl'] as String,
      hexColor: json['hexColor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
      'hexColor': hexColor,
    };
  }
}
