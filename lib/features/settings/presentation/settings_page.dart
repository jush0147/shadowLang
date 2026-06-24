import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();
  String _targetLanguage = 'zh-TW';
  bool _useMockGemini = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gemini', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use mock Gemini services'),
                  value: _useMockGemini,
                  onChanged: (value) => setState(() => _useMockGemini = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  enabled: !_useMockGemini,
                  decoration: const InputDecoration(
                    labelText: 'Gemini API key',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _targetLanguage,
                  decoration: const InputDecoration(
                    labelText: 'Default target language',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.translate),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'zh-TW', child: Text('Traditional Chinese')),
                    DropdownMenuItem(value: 'ja', child: Text('Japanese')),
                    DropdownMenuItem(value: 'ko', child: Text('Korean')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _targetLanguage = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
