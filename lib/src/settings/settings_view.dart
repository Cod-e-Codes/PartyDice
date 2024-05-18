/*
 * Copyright 2024 Cody Marsengill
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// lib/scr/settings/settings_view.dart

import 'package:flutter/material.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: 'settingsIcon',
              child: Transform.scale(
                scale: 1.5,
                child: const Icon(Icons.settings),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Settings'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAboutDialog(context),
              child: const Text('About'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showFutureUpdatesDialog(context),
              child: const Text('Future Updates'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Party Dice',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'assets/icon/icon.png',
        height: 50,
        width: 50,
        fit: BoxFit.scaleDown,
      ),
      applicationLegalese: '© 2024 CodēCodes. All rights reserved.',
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'This is a turn-based app for couples and friends.',
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  void _showFutureUpdatesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Future Updates'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '-Game Modes like team mode, free-for-all, family mode, online multiplayer, etc.\n\n'
                    '-Accessibility features for individuals with disabilities\n\n'
                    '-Localization and internationalization for other languages\n\n'
                    '-Achievements, player stats, game history, save/continue a game, share your results\n\n'
                    '-Home screen widgets\n\n'
                    '-Filters for actions and body parts\n\n'
                    '-Paid version with customizable actions and body parts\n\n\n\n'
                    'Stay tuned for exciting future updates!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
