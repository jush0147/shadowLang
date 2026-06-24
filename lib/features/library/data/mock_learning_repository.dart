import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../library/domain/content_item.dart';
import '../../player/domain/subtitle_segment.dart';
import '../../shadowing/domain/shadowing_attempt.dart';
import '../../vocabulary/domain/vocabulary_item.dart';

final learningRepositoryProvider = ChangeNotifierProvider<MockLearningRepository>((ref) {
  return MockLearningRepository.seeded();
});

class MockLearningRepository extends ChangeNotifier {
  MockLearningRepository.seeded() {
    final now = DateTime.now();
    _contents.add(
      ContentItem(
        id: _contentId,
        title: 'Test English Clip',
        sourceType: SourceType.localAudio,
        language: 'en',
        targetLanguage: 'zh-TW',
        createdAt: now,
        updatedAt: now,
      ),
    );
    _segments.addAll([
      SubtitleSegment(
        id: 'segment-1',
        contentId: _contentId,
        startMs: 0,
        endMs: 3200,
        text: 'I used to think learning languages was difficult.',
        translation: 'I once thought language learning was difficult.',
        tokenIds: const ['word-used-to', 'word-think', 'word-learning', 'word-languages', 'word-difficult'],
      ),
      SubtitleSegment(
        id: 'segment-2',
        contentId: _contentId,
        startMs: 3200,
        endMs: 6400,
        text: 'But shadowing helped me speak more naturally.',
        translation: 'But shadowing helped me speak more naturally.',
        tokenIds: const ['word-shadowing', 'word-helped', 'word-speak', 'word-naturally'],
      ),
    ]);
    _vocabulary.addAll([
      _word('word-used-to', 'used to', 'used to', 'past habit', 'phrase', VocabularyStatus.learning),
      _word('word-think', 'think', 'think', 'believe', 'verb', VocabularyStatus.known),
      _word('word-learning', 'learning', 'learn', 'studying', 'verb', VocabularyStatus.learning),
      _word('word-languages', 'languages', 'language', 'languages', 'noun', VocabularyStatus.known),
      _word('word-difficult', 'difficult', 'difficult', 'hard', 'adjective', VocabularyStatus.unknown),
      _word('word-shadowing', 'shadowing', 'shadow', 'repeat-after-audio practice', 'noun', VocabularyStatus.learning),
      _word('word-helped', 'helped', 'help', 'assisted', 'verb', VocabularyStatus.known),
      _word('word-speak', 'speak', 'speak', 'talk', 'verb', VocabularyStatus.learning),
      _word('word-naturally', 'naturally', 'naturally', 'in a natural way', 'adverb', VocabularyStatus.unknown),
    ]);
  }

  static const _contentId = 'content-test-english-clip';
  final _uuid = const Uuid();
  final List<ContentItem> _contents = [];
  final List<SubtitleSegment> _segments = [];
  final List<VocabularyItem> _vocabulary = [];
  final List<ShadowingAttempt> _attempts = [];

  VocabularyItem _word(
    String id,
    String text,
    String lemma,
    String translation,
    String partOfSpeech,
    VocabularyStatus status,
  ) {
    final now = DateTime.now();
    return VocabularyItem(
      id: id,
      language: 'en',
      text: text,
      lemma: lemma,
      translation: translation,
      partOfSpeech: partOfSpeech,
      status: status,
      seenCount: 1,
      createdAt: now,
      updatedAt: now,
    );
  }

  List<ContentItem> watchContents() => List.unmodifiable(_contents);

  ContentItem contentById(String id) => _contents.firstWhere((item) => item.id == id);

  List<SubtitleSegment> segmentsForContent(String contentId) {
    return _segments.where((segment) => segment.contentId == contentId).toList(growable: false);
  }

  List<VocabularyItem> allVocabulary() => List.unmodifiable(_vocabulary);

  List<VocabularyItem> vocabularyForSegment(SubtitleSegment segment) {
    return segment.tokenIds
        .map((id) => _vocabulary.firstWhere((word) => word.id == id))
        .toList(growable: false);
  }

  void updateVocabularyStatus(String vocabularyId, VocabularyStatus status) {
    final index = _vocabulary.indexWhere((word) => word.id == vocabularyId);
    if (index == -1) return;
    _vocabulary[index] = _vocabulary[index].copyWith(status: status, updatedAt: DateTime.now());
    notifyListeners();
  }

  ShadowingAttempt addShadowingAttempt({
    required String segmentId,
    required String userTranscript,
    required int score,
    required List<String> missingWords,
    required List<String> extraWords,
    required String feedbackZhTw,
    String? recordingPath,
  }) {
    final attempt = ShadowingAttempt(
      id: _uuid.v4(),
      segmentId: segmentId,
      recordingPath: recordingPath,
      userTranscript: userTranscript,
      score: score,
      missingWords: missingWords,
      extraWords: extraWords,
      feedbackZhTw: feedbackZhTw,
      createdAt: DateTime.now(),
    );
    _attempts.insert(0, attempt);
    notifyListeners();
    return attempt;
  }

  List<ShadowingAttempt> attemptsForSegment(String segmentId) {
    return _attempts.where((attempt) => attempt.segmentId == segmentId).toList(growable: false);
  }
}
