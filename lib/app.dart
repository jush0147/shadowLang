import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/import_content/presentation/import_content_page.dart';
import 'features/library/presentation/library_page.dart';
import 'features/player/presentation/player_page.dart';
import 'features/settings/presentation/settings_page.dart';
import 'features/vocabulary/presentation/vocabulary_page.dart';

class ShadowLangApp extends ConsumerStatefulWidget {
  const ShadowLangApp({super.key});

  @override
  ConsumerState<ShadowLangApp> createState() => _ShadowLangAppState();
}

class _ShadowLangAppState extends ConsumerState<ShadowLangApp> {
  int _index = 0;

  static const _pages = [
    LibraryPage(),
    ImportContentPage(),
    VocabularyPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShadowLang',
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      home: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.video_library_outlined),
                  selectedIcon: Icon(Icons.video_library),
                  label: Text('Library'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Text('Import'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.style_outlined),
                  selectedIcon: Icon(Icons.style),
                  label: Text('Words'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _pages[_index]),
          ],
        ),
        floatingActionButton: _index == 0
            ? FloatingActionButton.extended(
                onPressed: () => setState(() => _index = 1),
                icon: const Icon(Icons.add),
                label: const Text('Import'),
              )
            : null,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == PlayerPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => PlayerPage(contentId: settings.arguments! as String),
          );
        }
        return null;
      },
    );
  }
}
