import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat akun')),
      body: SafeArea(
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
            const SizedBox(height: 7),
            Text(
              'Buat akun Finding Kost untuk menemukan tempat tinggal yang pas.',
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 24),
            TextField(
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                labelText: 'Nama lengkap',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline_rounded),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                labelText: 'Kata sandi',
                helperText: 'Gunakan minimal 8 karakter.',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Daftar'),
            ),
            const SizedBox(height: 16),
            Text(
              'Dengan mendaftar, kamu menyetujui ketentuan penggunaan aplikasi.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
