import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Ganti tampilan tema ke mode gelap'),
            key: const Key('settings-theme-toggle'),
            value: appState.isDarkMode,
            onChanged: (_) => context.read<AppState>().toggleDarkMode(),
          ),
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan pemberitahuan sistem'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Versi Aplikasi'),
            subtitle: Text('v1.0.0 (UTS Mobile)'),
          ),
        ],
      ),
    );
  }
}
