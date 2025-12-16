# Seeding Firestore Database

## Overview
Since Dart standalone scripts cannot resolve Flutter/Firebase packages, here are **3 methods** to populate your Firestore database with the 5 royalty-free songs:

---

## Method 1: Manual Import via Firebase Console (Recommended)

### Steps:
1. **Open Firebase Console**: https://console.firebase.google.com/
2. **Select Project**: `spotifyclone-bacc2`
3. **Navigate to Firestore**: Click "Firestore Database" in the left sidebar
4. **Create Collection**: Click "Start collection"
   - Collection ID: `songs`
5. **Add Documents**: Click "Add document" and create 5 documents with the following data:

### Document 1
```
title: Digital Dreams
artist: Cyber Pulse
audioUrl: https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
coverUrl: https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=800&h=800&fit=crop
hexColor: #CCFF00
releaseDate: [Click "Add field" → Type: timestamp → Use current timestamp]
```

### Document 2
```
title: Neon Nights
artist: Retro Wave
audioUrl: https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3
coverUrl: https://images.unsplash.com/photo-1598387993281-cecf8b71a8f8?w=800&h=800&fit=crop
hexColor: #4D00FF
releaseDate: [1 day ago]
```

### Document 3
```
title: Glitch Horizon
artist: Pixel Beats
audioUrl: https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3
coverUrl: https://images.unsplash.com/photo-1611339555312-e607c8352fd7?w=800&h=800&fit=crop
hexColor: #000000
releaseDate: [2 days ago]
```

### Document 4
```
title: Synthwave Sunrise
artist: Echo Y2K
audioUrl: https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3
coverUrl: https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=800&h=800&fit=crop
hexColor: #FF00CC
releaseDate: [3 days ago]
```

### Document 5
```
title: Terminal Velocity
artist: Code Runner
audioUrl: https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3
coverUrl: https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=800&h=800&fit=crop
hexColor: #00FFFF
releaseDate: [4 days ago]
```

---

## Method 2: Import JSON via Firebase Console

1. Use the JSON data in `bin/songs_data.json`
2. Firebase Console → Firestore → Import
3. Select the JSON file
4. **Note**: You'll need to manually add `releaseDate` timestamps after import

---

## Method 3: Use Flutter App Initialization

Add this code to your app's initialization (e.g., in a debug/admin page):

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/features/home/domain/entities/song.dart';

Future<void> seedDatabase() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final songsCollection = firestore.collection('songs');

  final songs = [
    {
      'title': 'Digital Dreams',
      'artist': 'Cyber Pulse',
      'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'coverUrl': 'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=800&h=800&fit=crop',
      'hexColor': '#CCFF00',
      'releaseDate': Timestamp.now(),
    },
    // Add remaining 4 songs...
  ];

  for (var song in songs) {
    await songsCollection.add(song);
    print('✅ Added: ${song['title']}');
  }
}
```

---

## Verification

After importing, verify in Firebase Console:
- Collection: `songs`
- Document count: 5
- Each document has fields: `title`, `artist`, `audioUrl`, `coverUrl`, `hexColor`, `releaseDate`

---

## Song Data Reference

| # | Title | Artist | HexColor | Audio | Cover |
|---|-------|--------|----------|-------|-------|
| 1 | Digital Dreams | Cyber Pulse | #CCFF00 | SoundHelix-1.mp3 | Unsplash (abstract) |
| 2 | Neon Nights | Retro Wave | #4D00FF | SoundHelix-2.mp3 | Unsplash (neon) |
| 3 | Glitch Horizon | Pixel Beats | #000000 | SoundHelix-3.mp3 | Unsplash (glitch) |
| 4 | Synthwave Sunrise | Echo Y2K | #FF00CC | SoundHelix-4.mp3 | Unsplash (sunset) |
| 5 | Terminal Velocity | Code Runner | #00FFFF | SoundHelix-5.mp3 | Unsplash (motion) |

All audio: https://www.soundhelix.com/examples/  
All images: Unsplash (royalty-free)
