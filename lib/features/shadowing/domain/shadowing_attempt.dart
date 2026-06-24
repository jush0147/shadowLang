class ShadowingAttempt {
  const ShadowingAttempt({
    required this.id,
    required this.segmentId,
    required this.userTranscript,
    required this.score,
    required this.missingWords,
    required this.extraWords,
    required this.feedbackZhTw,
    required this.createdAt,
    this.recordingPath,
  });

  final String id;
  final String segmentId;
  final String? recordingPath;
  final String userTranscript;
  final int score;
  final List<String> missingWords;
  final List<String> extraWords;
  final String feedbackZhTw;
  final DateTime createdAt;
}
