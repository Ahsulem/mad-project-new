# Firebase Storage Upload Instructions

## ✅ MP3 Files Downloaded

Location: `temp_audio_files/` folder in your project

Files ready:
1. `Cyber Pulse - Digital Dreams.mp3`
2. `Retro Wave - Neon Nights.mp3`
3. `Pixel Beats - Glitch Horizon.mp3`
4. `Echo Y2K - Synthwave Sunrise.mp3`
5. `Code Runner - Terminal Velocity.mp3`

---

## 📤 Upload to Firebase Storage

### Step 1: Open Firebase Console
1. Go to: https://console.firebase.google.com/
2. Select project: **spotifyclone-bacc2**
3. Click **Storage** in left sidebar

### Step 2: Create Songs Folder
1. Click "Start" if first time, or navigate to root
2. Click **"Create folder"** button
3. Name it: `Songs`
4. Click **Create**

### Step 3: Upload MP3 Files
1. Open the `Songs` folder
2. Click **Upload file** button
3. Navigate to: `E:\MAD_Project-main\MAD_Project-main\spotify_clone-main\temp_audio_files\`
4. **Select all 5 MP3 files**
5. Click **Open** to upload

### Step 4: Verify Upload
After upload completes, you should see 5 files in the Songs folder:
- ✅ Cyber Pulse - Digital Dreams.mp3
- ✅ Retro Wave - Neon Nights.mp3
- ✅ Pixel Beats - Glitch Horizon.mp3
- ✅ Echo Y2K - Synthwave Sunrise.mp3  
- ✅ Code Runner - Terminal Velocity.mp3

---

## 🎵 Seed the Database

### In Your Running App:
1. Look for the **green "SEED DB" button** (bottom-right corner)
2. Click it to open the Database Seed Page
3. Click **"SEED DATABASE"** button
4. Wait for "Successfully seeded 5 songs!" message
5. Click **"DONE - Go Back"**

### Refresh Home Page:
- Pull down to refresh, or restart the app
- You should now see **5 songs** in the New section and Playlist!

---

## ✨ That's It!

Once both are done:
- **5 songs in Firestore**: Title, artist, duration, releaseDate
- **5 MP3s in Firebase Storage**: Ready to play

Songs will now load AND play correctly! 🎉
