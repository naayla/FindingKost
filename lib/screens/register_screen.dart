import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.pencariKost;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final appState = context.read<AppState>();
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : '+62 812 0000 0000',
      role: _selectedRole,
      institutionOrBusiness: _selectedRole == UserRole.pencariKost
          ? 'Universitas Sumatera Utara'
          : 'Pengelola Properti Kos Medan',
    );

    appState.setCurrentUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Akun berhasil dibuat sebagai ${_selectedRole.displayName}!',
        ),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const MainNavigationScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Baru')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            children: [
              const AppLogo(compact: true),
              const SizedBox(height: 24),
              Text(
                'Mulai perjalananmu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pilih jenis akunmu dan temukan atau pasarkan tempat tinggal.',
                style: TextStyle(color: colors.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Role Selector
              Text(
                'Daftar Sebagai:',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<UserRole>(
                segments: const [
                  ButtonSegment<UserRole>(
                    value: UserRole.pencariKost,
                    label: Text('Pencari Kost'),
                    icon: Icon(Icons.search_rounded),
                  ),
                  ButtonSegment<UserRole>(
                    value: UserRole.pemilikKost,
                    label: Text('Pemilik Kost'),
                    icon: Icon(Icons.home_work_rounded),
                  ),
                ],
                selected: {_selectedRole},
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedRole = selection.first;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  labelText: 'Nama Lengkap',
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Nama lengkap wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                  labelText: 'Email',
                ),
                validator: (val) => val == null || !val.contains('@')
                    ? 'Masukkan email yang valid.'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined),
                  labelText: 'Nomor WhatsApp / HP',
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  labelText: 'Kata sandi',
                  helperText: 'Gunakan minimal 8 karakter.',
                ),
                validator: (val) => val == null || val.length < 6
                    ? 'Kata sandi minimal 6 karakter.'
                    : null,
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _register,
                child: Text('Daftar sebagai ${_selectedRole.displayName}'),
              ),
              const SizedBox(height: 16),

              Text(
                'Dengan mendaftar, kamu menyetujui ketentuan penggunaan aplikasi Finding Kost.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
