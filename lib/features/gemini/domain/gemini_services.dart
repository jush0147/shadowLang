import '../../player/domain/subtitle_segment.dart';

abstract interface class GeminiTranslationService {
  Future<String> translateSegment(SubtitleSegment segment);
  Future<String> translateWord(String word, String context);
}

abstract interface class GeminiTranscriptionService {
  Future<List<SubtitleSegment>> generateSubtitlesFromAudio(String filePath);
}

abstract interface class GeminiShadowingService {
  Future<ShadowingComparison> compareShadowing({
    required String originalText,
    String? userAudioFile,
    String? userTranscript,
  });
}

class ShadowingComparison {
  const ShadowingComparison({
    required this.userTranscript,
    required this.score,
    required this.missingWords,
    required this.extraWords,
    required this.feedbackZhTw,
  });

  final String userTranscript;
  final int score;
  final List<String> missingWords;
  final List<String> extraWords;
  final String feedbackZhTw;
}
