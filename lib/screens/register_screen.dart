import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _institutionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final institution = _institutionController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi Nama, Email, dan Kata Sandi!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // Simpan semua data pendaftaran ke penyimpanan lokal
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone.isNotEmpty ? phone : '-');
    await prefs.setString('user_institution', institution.isNotEmpty ? institution : '-');
    await prefs.setString('user_password', password);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil! Silakan masuk.')),
      );
      Navigator.pop(context, true);
    }
  }

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
            const SizedBox(height: 20),
            Text(
              'Mulai perjalananmu',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Buat akun Finding Kost untuk menemukan tempat tinggal yang pas.',
              style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Nama Lengkap
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                labelText: 'Nama lengkap',
              ),
            ),
            const SizedBox(height: 12),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline_rounded),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 12),

            // Nomor WhatsApp
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined),
                labelText: 'Nomor WhatsApp / Kontak',
                hintText: '+62 812...',
              ),
            ),
            const SizedBox(height: 12),

            // Institusi / Kampus
            TextField(
              controller: _institutionController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.school_outlined),
                labelText: 'Institusi / Kampus',
                hintText: 'Contoh: Universitas Sumatera Utara',
              ),
            ),
            const SizedBox(height: 12),

            // Kata Sandi
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                labelText: 'Kata sandi',
                helperText: 'Gunakan minimal 8 karakter.',
              ),
            ),
            const SizedBox(height: 20),

            FilledButton(
              onPressed: _handleRegister,
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}