import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Seed script to populate Firestore with 5 royalty-free songs
/// Usage: dart bin/seed_songs.dart
void main() async {
  print('🎵 Spotify Data Layer - Seed Script');
  print('=' * 50);
  
  // Initialize Firebase
  print('\n🔄 Initializing Firebase...');
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCnn5MWfQOHMz1JBvqH7oBJDLr8my9K8aE',
        appId: '1:654974191226:android:2eab68eb9a90f912d09dc3',
        messagingSenderId: '654974191226',
        projectId: 'spotifyclone-bacc2',
        storageBucket: 'spotifyclone-bacc2.appspot.com',
      ),
    );
    print('✅ Firebase initialized successfully!\n');
  } catch (e) {
    print('⚠️  Firebase already initialized or connection error: $e\n');
    // Continue anyway - might already be initialized
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final songsCollection = firestore.collection('songs');

  // 5 royalty-free songs with Neubrutalism colors
  final songs = [
    {
      'title': 'Digital Dreams',
      'artist': 'Cyber Pulse',
      'audioUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'coverUrl':
          'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=800&h=800&fit=crop',
      'hexColor': '#CCFF00', // Acid Green
      'releaseDate': Timestamp.now(),
    },
    {
      'title': 'Neon Nights',
      'artist': 'Retro Wave',
      'audioUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'coverUrl':
          'https://images.unsplash.com/photo-1598387993281-cecf8b71a8f8?w=800&h=800&fit=crop',
      'hexColor': '#4D00FF', // Deep Purple
      'releaseDate': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 1))),
    },
    {
      'title': 'Glitch Horizon',
      'artist': 'Pixel Beats',
      'audioUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'coverUrl':
          'https://images.unsplash.com/photo-1611339555312-e607c8352fd7?w=800&h=800&fit=crop',
      'hexColor': '#000000', // Stark Black
      'releaseDate': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2))),
    },
    {
      'title': 'Synthwave Sunrise',
      'artist': 'Echo Y2K',
      'audioUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'coverUrl':
          'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=800&h=800&fit=crop',
      'hexColor': '#FF00CC', // Hot Pink (Y2K accent)
      'releaseDate': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 3))),
    },
    {
      'title': 'Terminal Velocity',
      'artist': 'Code Runner',
      'audioUrl':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      'coverUrl':
          'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=800&h=800&fit=crop',
      'hexColor': '#00FFFF', // Cyan (Y2K accent)
      'releaseDate': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 4))),
    },
  ];

  print('📦 Uploading 5 songs to Firestore...\n');

  try {
    int count = 0;
    for (var song in songs) {
      final docRef = await songsCollection.add(song);
      count++;
      print('  ✅ [$count/5] Added: "${song['title']}" by ${song['artist']}');
      print('      📝 ID: ${docRef.id}');
      print('      🎨 Color: ${song['hexColor']}\n');
    }

    print('=' * 50);
    print('🎉 Success! Seeded $count songs to Firestore');
    print('📊 Collection: songs');
    print('🔗 Check Firebase Console to verify data');
    print('\n✨ Data layer is ready for Phase 2!');
  } catch (e) {
    print('❌ Error seeding database: $e');
    exit(1);
  }
}
