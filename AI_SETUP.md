# AI DJ Setup Guide 🤖💿

To enable the AI DJ feature, you need a Google Gemini API Key.

## 1. Get an API Key
1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey).
2. Create a new API key (Free tier is fine).

## 2. Add Key to App
1. Open `lib/presentation/pages/home/pages/home.dart`.
2. Find line ~87 (inside `_showAiDjDialog`):
   ```dart
   const String apiKey = "YOUR_GEMINI_API_KEY"; 
   ```
3. Replace `"YOUR_GEMINI_API_KEY"` with your actual key (e.g., `"AIzaSy..."`).

## 3. Test It
1. Restart the app (`r` in terminal).
2. Click the **Sparkle Icon** (FAB) on the home screen.
3. Enter a mood (e.g., "Cyberpunk coding").
4. Click **Mix It**.
5. Watch the AI recommend 3 songs from your library!
