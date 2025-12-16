import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/song.dart';

class SongRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'songs';

  /// Fetch all songs from Firestore 'songs' collection
  Future<List<Song>> getAllSongs() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('releaseDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Song.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }

  /// Fetch a single song by ID
  Future<Song?> getSongById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      
      if (doc.exists) {
        return Song.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching song: $e');
      return null;
    }
  }

  /// Fetch new songs (limited to 10)
  Future<List<Song>> getNewSongs({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('releaseDate', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Song.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching new songs: $e');
      return [];
    }
  }
}
