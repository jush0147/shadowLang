import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../library/data/mock_learning_repository.dart';
import '../domain/vocabulary_item.dart';

class VocabularyPage extends ConsumerWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final words = repository.allVocabulary();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Vocabulary', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _CountChip(label: 'Unknown', count: words.where((w) => w.status == VocabularyStatus.unknown).length),
            _CountChip(label: 'Learning', count: words.where((w) => w.status == VocabularyStatus.learning).length),
            _CountChip(label: 'Known', count: words.where((w) => w.status == VocabularyStatus.known).length),
          ],
        ),
        const SizedBox(height: 24),
        for (final word in words) ...[
          Card(
            child: ListTile(
              leading: Icon(_iconFor(word.status)),
              title: Text(word.text),
              subtitle: Text('${word.translation} - ${word.lemma} - ${word.partOfSpeech}'),
              trailing: SegmentedButton<VocabularyStatus>(
                segments: const [
                  ButtonSegment(value: VocabularyStatus.unknown, icon: Icon(Icons.help_outline)),
                  ButtonSegment(value: VocabularyStatus.learning, icon: Icon(Icons.school_outlined)),
                  ButtonSegment(value: VocabularyStatus.known, icon: Icon(Icons.check_circle_outline)),
                ],
                selected: {word.status},
                showSelectedIcon: false,
                onSelectionChanged: (selection) {
                  repository.updateVocabularyStatus(word.id, selection.single);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  IconData _iconFor(VocabularyStatus status) {
    return switch (status) {
      VocabularyStatus.unknown => Icons.help_outline,
      VocabularyStatus.learning => Icons.school_outlined,
      VocabularyStatus.known => Icons.check_circle_outline,
    };
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label $count'));
  }
}
