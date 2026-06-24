enum VocabularyStatus { unknown, learning, known }

class VocabularyItem {
  const VocabularyItem({
    required this.id,
    required this.language,
    required this.text,
    required this.lemma,
    required this.translation,
    required this.partOfSpeech,
    required this.status,
    required this.seenCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String language;
  final String text;
  final String lemma;
  final String translation;
  final String partOfSpeech;
  final VocabularyStatus status;
  final int seenCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  VocabularyItem copyWith({
    VocabularyStatus? status,
    int? seenCount,
    DateTime? updatedAt,
  }) {
    return VocabularyItem(
      id: id,
      language: language,
      text: text,
      lemma: lemma,
      translation: translation,
      partOfSpeech: partOfSpeech,
      status: status ?? this.status,
      seenCount: seenCount ?? this.seenCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
