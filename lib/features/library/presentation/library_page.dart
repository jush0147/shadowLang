import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../library/data/mock_learning_repository.dart';
import '../../library/domain/content_item.dart';
import '../../player/presentation/player_page.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final contents = repository.watchContents();

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ShadowLang'),
              Text('Library', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList.separated(
            itemCount: contents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = contents[index];
              return _ContentTile(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _ContentTile extends StatelessWidget {
  const _ContentTile({required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(context).pushNamed(PlayerPage.routeName, arguments: item.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_iconFor(item.sourceType), color: colorScheme.onSecondaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(item.sourceType.name)),
                        Chip(label: Text('${item.language} -> ${item.targetLanguage}')),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(SourceType type) {
    return switch (type) {
      SourceType.localVideo => Icons.movie_outlined,
      SourceType.localAudio => Icons.graphic_eq,
      SourceType.youtube => Icons.play_circle_outline,
      SourceType.podcast => Icons.podcasts_outlined,
    };
  }
}
