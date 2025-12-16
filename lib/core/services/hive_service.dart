import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotify/features/profile/data/models/listening_event.dart';
import 'package:spotify/features/snap_to_song/data/models/vibe_session.dart';

class HiveService {
  static String? _currentUserId;
  static Box<VibeSession>? _vibeHistoryBox;
  static Box<ListeningEvent>? _listeningStatsBox;

  /// Initialize Hive and register adapters (called once in main)
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(VibeSessionAdapter());
    Hive.registerAdapter(ListeningEventAdapter());
  }

  /// Open user-specific boxes when user logs in
  static Future<void> openUserBoxes(String userId) async {
    if (_currentUserId == userId) return; // Already open for this user
    
    // Close existing boxes if any
    await closeUserBoxes();
    
    // Open new user-specific boxes
    _currentUserId = userId;
    _vibeHistoryBox = await Hive.openBox<VibeSession>('user_history_$userId');
    _listeningStatsBox = await Hive.openBox<ListeningEvent>('listening_stats_$userId');
    
    print('✅ Opened Hive boxes for user: $userId');
  }

  /// Close user boxes when user logs out
  static Future<void> closeUserBoxes() async {
    if (_vibeHistoryBox?.isOpen == true) {
      await _vibeHistoryBox!.close();
    }
    if (_listeningStatsBox?.isOpen == true) {
      await _listeningStatsBox!.close();
    }
    _vibeHistoryBox = null;
    _listeningStatsBox = null;
    _currentUserId = null;
    print('🔒 Closed user-specific Hive boxes');
  }

  /// Get vibe history box for current user
  static Box<VibeSession> get vibeHistoryBox {
    if (_vibeHistoryBox == null || !_vibeHistoryBox!.isOpen) {
      throw Exception('Vibe history box not open. User might not be logged in.');
    }
    return _vibeHistoryBox!;
  }

  /// Get listening stats box for current user
  static Box<ListeningEvent> get listeningStatsBox {
    if (_listeningStatsBox == null || !_listeningStatsBox!.isOpen) {
      throw Exception('Listening stats box not open. User might not be logged in.');
    }
    return _listeningStatsBox!;
  }

  /// Listen to auth state and manage boxes accordingly
  static void setupAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // User logged in
        await openUserBoxes(user.uid);
      } else {
        // User logged out
        await closeUserBoxes();
      }
    });
  }
}
