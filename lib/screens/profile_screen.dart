import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_role.dart';
import '../providers/app_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _editProfile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final appState = context.read<AppState>();
    final user = appState.currentUser;

    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => _EditProfileDialog(
        name: user.name,
        email: user.email,
        phone: user.phone,
        institution: user.institutionOrBusiness ?? '',
      ),
    );

    if (result != null) {
      appState.updateProfile(
        name: result[0],
        email: result[1],
        phone: result[2],
        institutionOrBusiness: result[3],
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui.')),
      );
    }
  }

  void _switchRoleDemo(BuildContext context) {
    final appState = context.read<AppState>();
    final newRole = appState.isOwner ? UserRole.pencariKost : UserRole.pemilikKost;
    appState.setRole(newRole);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beralih mode peran ke ${newRole.displayName}!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appState = context.watch<AppState>();
    final user = appState.currentUser;
    final isOwner = appState.isOwner;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        actions: [
          IconButton(
            tooltip: 'Ganti Mode Peran (Demo)',
            icon: Icon(
              isOwner ? Icons.swap_horiz_rounded : Icons.real_estate_agent_rounded,
              color: colors.primary,
            ),
            onPressed: () => _switchRoleDemo(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          // Header Profile Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isOwner
                    ? [
                        colors.secondary,
                        colors.secondary.withValues(alpha: 0.85),
                      ]
                    : [
                        colors.primary,
                        colors.primary.withValues(alpha: 0.85),
                      ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: colors.onPrimary.withValues(alpha: 0.18),
                  child: Text(
                    _initials(user.name),
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),

                // Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Akun ${user.role.displayName}',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _editProfile(context),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit Profil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onPrimary,
                        side: BorderSide(
                          color: colors.onPrimary.withValues(alpha: 0.5),
                        ),
                        backgroundColor: colors.onPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _switchRoleDemo(context),
                      icon: const Icon(Icons.swap_calls_rounded, size: 16),
                      label: Text(
                        isOwner ? 'Mode Pencari' : 'Mode Pemilik',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.onPrimary,
                        foregroundColor:
                            isOwner ? colors.secondary : colors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Stats based on role
          Row(
            children: [
              Expanded(
                child: _ProfileStat(
                  icon: isOwner
                      ? Icons.home_work_outlined
                      : Icons.bookmark_outline_rounded,
                  value: isOwner
                      ? '${appState.ownerItems.length}'
                      : '${appState.favoriteKostIds.length}',
                  label: isOwner ? 'Katalog Milik Saya' : 'Kos Tersimpan',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileStat(
                  icon: Icons.category_outlined,
                  value: '${appState.categories.length}',
                  label: 'Kategori Kos',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Informasi Akun',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),

          _ProfileInfoTile(
            icon: Icons.mail_outline_rounded,
            label: 'Email Registered',
            value: user.email,
          ),
          const SizedBox(height: 10),

          _ProfileInfoTile(
            icon: Icons.phone_outlined,
            label: 'Nomor WhatsApp / Kontak',
            value: user.phone,
          ),
          const SizedBox(height: 10),

          _ProfileInfoTile(
            icon: isOwner ? Icons.business_outlined : Icons.school_outlined,
            label: isOwner ? 'Pengelola Properti' : 'Institusi / Kampus',
            value: user.institutionOrBusiness ?? '-',
          ),
          const SizedBox(height: 24),

          // Role Switcher info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: colors.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akses Berbeda Berdasarkan Peran',
                        style: TextStyle(
                          color: colors.onSecondaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isOwner
                            ? 'Sebagai Pemilik Kost, Anda dapat membuat dan mengelola katalog kos.'
                            : 'Sebagai Pencari Kost, Anda dapat menjelajahi dan menyimpan kos impian.',
                        style: TextStyle(
                          color: colors.onSecondaryContainer.withValues(
                            alpha: 0.85,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            label: const Text(
              'Keluar dari Akun',
              style: TextStyle(color: Colors.redAccent),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts
        .take(2)
        .map((part) => part.isEmpty ? '' : part[0].toUpperCase())
        .join();
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.name,
    required this.email,
    required this.phone,
    required this.institution,
  });

  final String name;
  final String email;
  final String phone;
  final String institution;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _instController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _instController = TextEditingController(text: widget.institution);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama tidak boleh kosong.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Masukkan alamat email yang valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instController,
                decoration: const InputDecoration(
                  labelText: 'Institusi / usaha',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, [
                _nameController.text.trim(),
                _emailController.text.trim(),
                _phoneController.text.trim(),
                _instController.text.trim(),
              ]);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
