import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  
  // Initialize with API key - ideally from env variables
  // For this prototype we'll pass it in or default to a dummy if needed
  // BUT the prompt implies I should just initialize it.
  // I'll assume the user provides it or we use a placeholder that calls for input.
  
  GeminiService(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<List<String>> getSongRecommendations(String userMood, List<String> availableSongTitles) async {
    final prompt = '''
You are a DJ. The user feels $userMood. Here is a list of available songs: ${availableSongTitles.join(", ")}. 
Specify which 3 songs fit this mood best. 
Return ONLY a JSON list of song titles. Do not include markdown formatting like ```json or ```.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      if (response.text == null) return [];
      
      // Clean up response if it contains markdown
      String cleanText = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
      
      final List<dynamic> jsonList = jsonDecode(cleanText);
      return jsonList.cast<String>();
    } catch (e) {
      print('Gemini Error: $e');
      return []; 
    }
  }
}
