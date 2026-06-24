import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time_format.dart';
import '../../gemini/data/mock_gemini_services.dart';
import '../../library/data/mock_learning_repository.dart';
import '../../player/data/mock_audio_player.dart';
import '../../player/domain/subtitle_segment.dart';
import '../../vocabulary/domain/vocabulary_item.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({required this.contentId, super.key});

  static const routeName = '/player';

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final player = ref.watch(mockAudioPlayerProvider);
    final playerController = ref.read(mockAudioPlayerProvider.notifier);
    final content = repository.contentById(contentId);
    final segments = repository.segmentsForContent(contentId);
    final activeSegment = segments.where((segment) => segment.containsPosition(player.positionMs)).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(content.title)),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MockMediaSurface(
                    title: content.title,
                    currentText: activeSegment?.text ?? 'Ready',
                  ),
                  const SizedBox(height: 16),
                  _PlaybackControls(
                    state: player,
                    onToggle: playerController.toggle,
                    onSeek: (value) => playerController.seek(value.round()),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: segments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final segment = segments[index];
                        return _SubtitleCard(
                          segment: segment,
                          isActive: segment.id == activeSegment?.id,
                          onTap: () => playerController.seek(segment.startMs),
                          onWordTap: (word) => _showWordSheet(context, repository, word),
                          onShadow: () => _showShadowingSheet(context, ref, segment),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          SizedBox(
            width: 320,
            child: _VocabularyPanel(activeSegment: activeSegment),
          ),
        ],
      ),
    );
  }

  void _showWordSheet(
    BuildContext context,
    MockLearningRepository repository,
    VocabularyItem word,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _WordSheet(repository: repository, word: word),
    );
  }

  Future<void> _showShadowingSheet(
    BuildContext context,
    WidgetRef ref,
    SubtitleSegment segment,
  ) async {
    final repository = ref.read(learningRepositoryProvider);
    final service = MockGeminiShadowingService();
    final result = await service.compareShadowing(originalText: segment.text);
    repository.addShadowingAttempt(
      segmentId: segment.id,
      userTranscript: result.userTranscript,
      score: result.score,
      missingWords: result.missingWords,
      extraWords: result.extraWords,
      feedbackZhTw: result.feedbackZhTw,
    );
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shadowing Feedback', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Score: ${result.score}'),
            const SizedBox(height: 8),
            Text('Transcript: ${result.userTranscript}'),
            const SizedBox(height: 8),
            Text(result.feedbackZhTw),
          ],
        ),
      ),
    );
  }
}

class _MockMediaSurface extends StatelessWidget {
  const _MockMediaSurface({required this.title, required this.currentText});

  final String title;
  final String currentText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            Text(currentText, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({
    required this.state,
    required this.onToggle,
    required this.onSeek,
  });

  final PlaybackState state;
  final VoidCallback onToggle;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          tooltip: state.isPlaying ? 'Pause' : 'Play',
          onPressed: onToggle,
          icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        const SizedBox(width: 12),
        Text(formatDurationMs(state.positionMs)),
        Expanded(
          child: Slider(
            value: state.positionMs.toDouble(),
            max: state.durationMs.toDouble(),
            onChanged: onSeek,
          ),
        ),
        Text(formatDurationMs(state.durationMs)),
      ],
    );
  }
}

class _SubtitleCard extends ConsumerWidget {
  const _SubtitleCard({
    required this.segment,
    required this.isActive,
    required this.onTap,
    required this.onWordTap,
    required this.onShadow,
  });

  final SubtitleSegment segment;
  final bool isActive;
  final VoidCallback onTap;
  final ValueChanged<VocabularyItem> onWordTap;
  final VoidCallback onShadow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final words = repository.vocabularyForSegment(segment);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isActive ? colorScheme.secondaryContainer : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${formatDurationMs(segment.startMs)} - ${formatDurationMs(segment.endMs)}'),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Shadow',
                    onPressed: onShadow,
                    icon: const Icon(Icons.mic_none),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(segment.text, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(segment.translation),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final word in words)
                    ActionChip(
                      label: Text(word.text),
                      avatar: Icon(_statusIcon(word.status), size: 18),
                      onPressed: () => onWordTap(word),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(VocabularyStatus status) {
    return switch (status) {
      VocabularyStatus.unknown => Icons.help_outline,
      VocabularyStatus.learning => Icons.school_outlined,
      VocabularyStatus.known => Icons.check_circle_outline,
    };
  }
}

class _VocabularyPanel extends ConsumerWidget {
  const _VocabularyPanel({required this.activeSegment});

  final SubtitleSegment? activeSegment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final words = activeSegment == null ? <VocabularyItem>[] : repository.vocabularyForSegment(activeSegment!);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Current Words', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final word in words)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(word.text),
            subtitle: Text('${word.translation} - ${word.partOfSpeech}'),
            trailing: Text(word.status.name),
          ),
      ],
    );
  }
}

class _WordSheet extends ConsumerWidget {
  const _WordSheet({required this.repository, required this.word});

  final MockLearningRepository repository;
  final VocabularyItem word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(word.text, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${word.lemma} - ${word.partOfSpeech}'),
          const SizedBox(height: 8),
          Text(word.translation),
          const SizedBox(height: 16),
          SegmentedButton<VocabularyStatus>(
            segments: const [
              ButtonSegment(value: VocabularyStatus.unknown, label: Text('Unknown')),
              ButtonSegment(value: VocabularyStatus.learning, label: Text('Learning')),
              ButtonSegment(value: VocabularyStatus.known, label: Text('Known')),
            ],
            selected: {word.status},
            onSelectionChanged: (selection) {
              repository.updateVocabularyStatus(word.id, selection.single);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
