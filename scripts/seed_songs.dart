import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Firebase configuration for Windows (manual setup)
const firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyAJC6h_HlF9YgN9H8jvH0P7wZvN1xRzXYw',
  appId: '1:123456789:web:abcdef1234567890',
  messagingSenderId: '123456789',
  projectId: 'spotify-clone-project',
  storageBucket: 'spotify-clone-project.appspot.com',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const SeedApp());
}

class SeedApp extends StatefulWidget {
  const SeedApp({super.key});

  @override
  State<SeedApp> createState() => _SeedAppState();
}

class _SeedAppState extends State<SeedApp> {
  String status = 'Initializing Firebase...';
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    seedDatabase();
  }

  Future<void> seedDatabase() async {
    try {
      // Try to initialize Firebase with the options from firebase_options.dart
      await Firebase.initializeApp();
      
      setState(() {
        status = '🔄 Starting database seed...\n';
      });

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final songsCollection = firestore.collection('Songs');

      // 5 royalty-free songs with Neubrutalism aesthetic colors
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

      StringBuffer output = StringBuffer('🔄 Starting database seed...\n\n');
      int count = 0;
      
      for (var song in songs) {
        final docRef = await songsCollection.add(song);
        count++;
        output.writeln('✅ [$count/5] Added: "${song['title']}" - ID: ${docRef.id}');
      }

      output.writeln('\n🎉 Successfully seeded $count songs to Firestore!');
      output.writeln('📊 Collection: Songs');
      output.writeln('🔗 Check Firebase Console to verify data');

      setState(() {
        status = output.toString();
        isComplete = true;
      });

      print(output.toString());
    } catch (e) {
      setState(() {
        status = '❌ Error seeding database: $e';
      });
      print('❌ Error seeding database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFCCFF00),
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SPOTIFY SEED SCRIPT',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (!isComplete)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 600,
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

