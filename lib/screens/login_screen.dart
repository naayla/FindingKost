import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../widgets/app_logo.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'nana@example.com');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
  }

  Future<void> _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');

    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
        if (savedPassword != null && savedPassword.isNotEmpty) {
          _passwordController.text = savedPassword;
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginAsRole(UserRole role) async {
    final appState = context.read<AppState>();
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('user_name');
    final savedEmail = prefs.getString('user_email');
    final savedPhone = prefs.getString('user_phone');
    final savedInstitution = prefs.getString('user_institution');
    final inputEmail = _emailController.text.trim();

    if (role == UserRole.pemilikKost) {
      appState.setCurrentUser(
        UserModel(
          id: 'user_owner_1',
          name: (savedName != null && savedName.isNotEmpty)
              ? savedName
              : 'Ibu Hj. Aminah',
          email: (savedEmail != null && savedEmail.isNotEmpty)
              ? savedEmail
              : (inputEmail.isNotEmpty ? inputEmail : 'owner.aminah@example.com'),
          phone: (savedPhone != null && savedPhone.isNotEmpty)
              ? savedPhone
              : '+62 813 9876 5432',
          role: UserRole.pemilikKost,
          institutionOrBusiness: (savedInstitution != null && savedInstitution.isNotEmpty)
              ? savedInstitution
              : 'Pemilik Kos Harmoni & Grand Residence',
        ),
      );
    } else {
      appState.setCurrentUser(
        UserModel(
          id: 'user_seeker_1',
          name: (savedName != null && savedName.isNotEmpty)
              ? savedName
              : 'Nayla Syifa Tanjung',
          email: (savedEmail != null && savedEmail.isNotEmpty)
              ? savedEmail
              : (inputEmail.isNotEmpty ? inputEmail : 'nayla@example.com'),
          phone: (savedPhone != null && savedPhone.isNotEmpty)
              ? savedPhone
              : '+62 812 3456 7890',
          role: UserRole.pencariKost,
          institutionOrBusiness: (savedInstitution != null && savedInstitution.isNotEmpty)
              ? savedInstitution
              : 'Universitas Sumatera Utara',
        ),
      );
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = context.watch<AppState>().isDarkMode;

    final headerTextColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final subtextColor = isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF475569);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [
                    colors.surface,
                    colors.surfaceContainer,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFE2EBE4),
                    Color(0xFFF7F0E6),
                    Color(0xFFFAF8F5),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      key: const Key('theme-toggle'),
                      tooltip: 'Ganti tema',
                      onPressed: context.read<AppState>().toggleDarkMode,
                      icon: Icon(
                        isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: headerTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 0.85,
                            alignment: Alignment.centerLeft,
                            child: const AppLogo(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Selamat datang finder',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: headerTextColor,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 280,
                            child: Text(
                              'Masuk untuk mulai mencari dan memesan kos impianmu.',
                              style: TextStyle(
                                color: subtextColor,
                                fontSize: 14,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form Card (Khusus Pencari Kost)
                          Card(
                            elevation: isDarkMode ? 1 : 4,
                            shadowColor: Colors.black.withValues(alpha: 0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: isDarkMode
                                ? colors.surfaceContainer
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.search_rounded, color: colors.primary, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Masuk sebagai Pencari Kost',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),

                                  // Input Email
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      prefixIcon: Icon(
                                          Icons.mail_outline_rounded,
                                          size: 20),
                                      hintText: 'Masukkan email anda',
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Input Kata Sandi
                                  Text(
                                    'Kata sandi',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      prefixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          size: 20),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      hintText: 'Masukkan sandi anda',
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Tombol Masuk Utama (Pencari Kost)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: FilledButton(
                                      onPressed: () {
                                        _loginAsRole(UserRole.pencariKost);
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: const Text(
                                        'Masuk sebagai Pencari Kost',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Opsi Daftar
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Belum punya akun? ',
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  const RegisterScreen(),
                                            ),
                                          ).then((_) {
                                            _loadSavedAccount();
                                          });
                                        },
                                        child: Text(
                                          'Daftar sekarang',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tombol Alternatif Portal Pemilik Kost
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _loginAsRole(UserRole.pemilikKost);
                              },
                              icon: const Icon(Icons.storefront_rounded, size: 18),
                              label: const Text(
                                'Masuk sebagai Pemilik Kost (Kelola Properti)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
