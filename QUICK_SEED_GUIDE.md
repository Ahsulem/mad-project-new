# Quick Database Seeding (In-App Method)

Since the Dart standalone script doesn't work, use this in-app method:

## Step 1: Add Seed Page to App

Temporarily add this import and route to your `main.dart` or create a debug button:

```dart
import 'package:spotify/presentation/admin/pages/database_seed_page.dart';

// In your routes or anywhere accessible:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DatabaseSeedPage()),
);
```

## Step 2: Navigate and Seed

1. Run the app on Edge: `flutter run -d edge`
2. Navigate to the DatabaseSeedPage
3. Click "SEED DATABASE" button
4. Wait for confirmation
5. Refresh your home page

## Step 3: Upload Audio Files to Firebase Storage

The current app expects MP3 files in Firebase Storage at:
`https://firebasestorage.googleapis.com/v0/b/spotifyclone-bacc2.appspot.com/o/Songs/`

**To fix audio playback**, upload 5 MP3 files named:
- `Cyber Pulse - Digital Dreams.mp3`
- `Retro Wave - Neon Nights.mp3`
- `Pixel Beats - Glitch Horizon.mp3`
- `Echo Y2K - Synthwave Sunrise.mp3`
- `Code Runner - Terminal Velocity.mp3`

**Quick Alternative**: Use free MP3 files from:
- https://www.soundhelix.com/examples/ (download SoundHelix-Song-1 through 5)
- Rename them to match the pattern above
- Upload to Firebase Storage → Songs folder

---

## Alternative: Manual Firestore Entry

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select project: `spotifyclone-bacc2`
3. Firestore Database → Add 5 documents to `Songs` collection
4. Each document needs:
   - `title`: string
   - `artist`: string
   - `duration`: number (in seconds)
   - `releaseDate`: timestamp

---

## Why Songs Don't Play Currently

The app constructs audio URLs like:
```
https://firebasestorage.googleapis.com/v0/b/spotifyclone-bacc2.appspot.com/o/Songs/Artist%20-%20Title.mp3?alt=media
```

But there are no MP3 files uploaded to Firebase Storage yet. You need to either:
1. Upload MP3s to Firebase Storage (Songs folder)
2. OR modify the song player to use direct URLs (like SoundHelix)
