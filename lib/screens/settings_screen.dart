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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Sesuaikan pengalamanmu',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.7),
          ),
          const SizedBox(height: 6),
          Text(
            'Atur tampilan dan preferensi aplikasi.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          _SettingsSection(
            title: 'Tampilan',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mode gelap'),
                subtitle: const Text('Lebih nyaman untuk suasana minim cahaya'),
                secondary: _SettingsIcon(
                  icon: appState.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                key: const Key('settings-theme-toggle'),
                value: appState.isDarkMode,
                onChanged: (_) => context.read<AppState>().toggleDarkMode(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingsSection(
            title: 'Notifikasi',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pengingat dan kabar terbaru'),
                subtitle: const Text(
                  'Atur preferensi notifikasi selama menggunakan aplikasi',
                ),
                secondary: const _SettingsIcon(
                  icon: Icons.notifications_none_rounded,
                ),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SettingsSection(
            title: 'Tentang aplikasi',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _SettingsIcon(icon: Icons.info_outline_rounded),
                title: const Text('Finding Kost'),
                subtitle: const Text('Versi 1.0.0 • Temukan ruang nyamanmu'),
                trailing: Icon(
                  Icons.verified_rounded,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const Divider(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _SettingsIcon(icon: Icons.shield_outlined),
                title: const Text('Privasi dan keamanan'),
                subtitle: const Text(
                  'Data profil tersimpan di perangkat sesi ini',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Dibuat dengan sepenuh hati untuk pencari kos.',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: colors.onPrimaryContainer, size: 20),
    );
  }
}
