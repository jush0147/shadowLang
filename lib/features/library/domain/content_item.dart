enum SourceType { localVideo, localAudio, youtube, podcast }

class ContentItem {
  const ContentItem({
    required this.id,
    required this.title,
    required this.sourceType,
    required this.language,
    required this.targetLanguage,
    required this.createdAt,
    required this.updatedAt,
    this.sourceUrl,
    this.localFilePath,
    this.lastPositionMs = 0,
  });

  final String id;
  final String title;
  final SourceType sourceType;
  final String? sourceUrl;
  final String? localFilePath;
  final String language;
  final String targetLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int lastPositionMs;

  ContentItem copyWith({
    String? id,
    String? title,
    SourceType? sourceType,
    String? sourceUrl,
    String? localFilePath,
    String? language,
    String? targetLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? lastPositionMs,
  }) {
    return ContentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      sourceType: sourceType ?? this.sourceType,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      localFilePath: localFilePath ?? this.localFilePath,
      language: language ?? this.language,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPositionMs: lastPositionMs ?? this.lastPositionMs,
    );
  }
}
