class SubtitleSegment {
  const SubtitleSegment({
    required this.id,
    required this.contentId,
    required this.startMs,
    required this.endMs,
    required this.text,
    required this.translation,
    required this.tokenIds,
  });

  final String id;
  final String contentId;
  final int startMs;
  final int endMs;
  final String text;
  final String translation;
  final List<String> tokenIds;

  bool containsPosition(int positionMs) {
    return positionMs >= startMs && positionMs < endMs;
  }
}
