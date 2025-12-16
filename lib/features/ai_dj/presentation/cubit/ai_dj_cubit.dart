import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/features/ai_dj/data/datasources/gemini_service.dart';
import 'package:spotify/core/services/hive_service.dart';
import 'package:spotify/features/snap_to_song/data/models/vibe_session.dart';
import 'ai_dj_state.dart';

class AiDjCubit extends Cubit<AiDjState> {
  final GeminiService _geminiService;

  AiDjCubit({required String apiKey}) 
      : _geminiService = GeminiService(apiKey), 
        super(AiDjInitial());

  Future<void> getRecommendations(String mood, List<String> availableSongs, {List<String>? detectedLabels}) async {
    emit(AiDjLoading());
    try {
      final recommendations = await _geminiService.getSongRecommendations(mood, availableSongs);
      if (recommendations.isEmpty) {
        emit(AiDjError("No recommendations found or API error."));
      } else {
        // Log to Hive
        try {
            final session = VibeSession(
                timestamp: DateTime.now(),
                detectedLabels: detectedLabels ?? [mood],
                suggestedSongs: recommendations,
            );
            HiveService.vibeHistoryBox.add(session);
            print("Logged VibeSession to Hive: $session");
        } catch (e) {
            print("Hive Log Error: $e");
        }
        
        emit(AiDjLoaded(recommendations));
      }
    } catch (e) {
      emit(AiDjError(e.toString()));
    }
  }
}
