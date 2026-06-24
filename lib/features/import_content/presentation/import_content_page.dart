import 'package:flutter/material.dart';

class ImportContentPage extends StatelessWidget {
  const ImportContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Import Content', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 24),
        const _ImportOption(
          icon: Icons.audio_file_outlined,
          title: 'Local audio',
          subtitle: 'Mocked for desktop MVP; native file picker comes later.',
        ),
        const SizedBox(height: 12),
        const _ImportOption(
          icon: Icons.movie_outlined,
          title: 'Local video',
          subtitle: 'Ready as a source type; playback remains mocked for now.',
        ),
        const SizedBox(height: 12),
        const _ImportOption(
          icon: Icons.subtitles_outlined,
          title: 'SRT / VTT subtitles',
          subtitle: 'Parser hooks are reserved for the database phase.',
        ),
        const SizedBox(height: 12),
        const _ImportOption(
          icon: Icons.link,
          title: 'YouTube / podcast URL',
          subtitle: 'Kept out of MVP runtime to avoid WebView and platform permissions.',
        ),
      ],
    );
  }
}

class _ImportOption extends StatelessWidget {
  const _ImportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 18,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: FilledButton.tonalIcon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Mock'),
        ),
      ),
    );
  }
}
