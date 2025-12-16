import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Admin page to seed database with 5 royalty-free songs
/// Add this to your app temporarily to seed the database
class DatabaseSeedPage extends StatefulWidget {
  const DatabaseSeedPage({super.key});

  @override
  State<DatabaseSeedPage> createState() => _DatabaseSeedPageState();
}

class _DatabaseSeedPageState extends State<DatabaseSeedPage> {
  String status = 'Ready to seed database...';
  bool isSeeding = false;
  bool isComplete = false;

  Future<void> seedDatabase() async {
    setState(() {
      isSeeding = true;
      status = '🔄 Starting database seed...\n';
    });

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final songsCollection = firestore.collection('Songs');

    // 5 royalty-free songs with working audio URLs
    final songs = [
      {
        'title': 'Digital Dreams',
        'artist': 'Cyber Pulse',
        'duration': 180, // 3 minutes in seconds
        'releaseDate': Timestamp.now(),
      },
      {
        'title': 'Neon Nights',
        'artist': 'Retro Wave',
        'duration': 200,
        'releaseDate': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
      },
      {
        'title': 'Glitch Horizon',
        'artist': 'Pixel Beats',
        'duration': 195,
        'releaseDate': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 2))),
      },
      {
        'title': 'Synthwave Sunrise',
        'artist': 'Echo Y2K',
        'duration': 210,
        'releaseDate': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 3))),
      },
      {
        'title': 'Terminal Velocity',
        'artist': 'Code Runner',
        'duration': 185,
        'releaseDate': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 4))),
      },
    ];

    try {
      int count = 0;
      String output = '';
      
      for (var song in songs) {
        final docRef = await songsCollection.add(song);
        count++;
        output += '✅ [$count/5] Added: "${song['title']}"\n   ID: ${docRef.id}\n\n';
      }

      setState(() {
        status = '🎉 Successfully seeded $count songs!\n\n$output\n📊 Collection: Songs\n✨ Ready for use!';
        isComplete = true;
        isSeeding = false;
      });
    } catch (e) {
      setState(() {
        status = '❌ Error seeding database: $e';
        isSeeding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Database Seed Utility'),
        backgroundColor: const Color(0xFFCCFF00),
        foregroundColor: Colors.black,
      ),
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
              const Text(
                'SPOTIFY DATABASE SEEDER',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              if (isSeeding && !isComplete)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!isSeeding && !isComplete)
                ElevatedButton(
                  onPressed: seedDatabase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D00FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'SEED DATABASE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isComplete)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'DONE - Go Back',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
