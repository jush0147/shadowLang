import '../../player/domain/subtitle_segment.dart';
import '../domain/gemini_services.dart';

class MockGeminiTranslationService implements GeminiTranslationService {
  @override
  Future<String> translateSegment(SubtitleSegment segment) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return segment.translation;
  }

  @override
  Future<String> translateWord(String word, String context) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return '$word is used in a context-sensitive way in this sentence.';
  }
}

class MockGeminiTranscriptionService implements GeminiTranscriptionService {
  @override
  Future<List<SubtitleSegment>> generateSubtitlesFromAudio(String filePath) {
    throw UnimplementedError('MVP uses imported subtitles or seed data.');
  }
}

class MockGeminiShadowingService implements GeminiShadowingService {
  @override
  Future<ShadowingComparison> compareShadowing({
    required String originalText,
    String? userAudioFile,
    String? userTranscript,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final transcript = userTranscript?.trim().isNotEmpty == true
        ? userTranscript!.trim()
        : originalText.replaceAll('naturally', 'natural');

    return ShadowingComparison(
      userTranscript: transcript,
      score: transcript == originalText ? 96 : 82,
      missingWords: transcript == originalText ? const [] : const ['naturally'],
      extraWords: const [],
      feedbackZhTw: 'Rhythm is close. Next time, focus on final stress and the ending of naturally.',
    );
  }
}
