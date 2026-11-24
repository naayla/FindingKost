import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>(); // Ditambahkan FormKey untuk validasi
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.pencariKost;
  bool _obscurePassword = true;
  bool _isLoading = false; // Indikator loading saat proses masuk

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

  // Fungsi Login yang terhubung ke Firebase Authentication
  Future<void> _loginAsRole(UserRole role) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Autentikasi dengan Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final appState = context.read<AppState>();
      final prefs = await SharedPreferences.getInstance();

      final savedName = prefs.getString('user_name');
      final savedPhone = prefs.getString('user_phone');
      final savedInstitution = prefs.getString('user_institution');
      final userEmail = userCredential.user?.email ?? _emailController.text.trim();

      // 2. Set data user ke AppState sesuai role yang dipilih
      if (role == UserRole.pemilikKost) {
        appState.setCurrentUser(
          UserModel(
            id: userCredential.user?.uid ?? 'user_owner_1',
            name: (savedName != null && savedName.isNotEmpty) ? savedName : 'Pemilik Kos',
            email: userEmail,
            phone: savedPhone ?? '',
            role: UserRole.pemilikKost,
            institutionOrBusiness: savedInstitution ?? 'Pemilik Kos Mandiri',
          ),
        );
      } else {
        appState.setCurrentUser(
          UserModel(
            id: userCredential.user?.uid ?? 'user_seeker_1',
            name: (savedName != null && savedName.isNotEmpty) ? savedName : 'Pencari Kost',
            email: userEmail,
            phone: savedPhone ?? '',
            role: UserRole.pencariKost,
            institutionOrBusiness: savedInstitution ?? '',
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Berhasil! Selamat datang.'),
            backgroundColor: Color(0xFF2D6A4F),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const MainNavigationScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan saat masuk.';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = 'Email atau kata sandi salah / akun tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Kata sandi salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
        message = e.message ?? message;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = context.watch<AppState>().isDarkMode;

    final headerTextColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final subtextColor = isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF475569);

    final isSeeker = _selectedRole == UserRole.pencariKost;

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
                            isSeeker ? 'Selamat Datang Finder' : 'Portal Pemilik Kos',
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
                            width: 290,
                            child: Text(
                              isSeeker
                                  ? 'Masuk untuk mulai mencari dan memesan kos impianmu.'
                                  : 'Masuk untuk mengelola properti, kamar, dan pesan masuk.',
                              style: TextStyle(
                                color: subtextColor,
                                fontSize: 14,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

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
                              child: Form(
                                key: _formKey, // Dibungkus dengan Form Widget
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 46,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: colors.surfaceContainerHighest
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => setState(() =>
                                              _selectedRole =
                                                  UserRole.pencariKost),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: isSeeker
                                                      ? colors.primary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                  BorderRadius.circular(19),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.search_rounded,
                                                      size: 16,
                                                      color: isSeeker
                                                          ? colors.onPrimary
                                                          : colors.onSurface,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Pencari Kost',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: isSeeker
                                                            ? colors.onPrimary
                                                            : colors.onSurface,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => setState(() =>
                                              _selectedRole =
                                                  UserRole.pemilikKost),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: !isSeeker
                                                      ? colors.primary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                  BorderRadius.circular(19),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.storefront_rounded,
                                                      size: 16,
                                                      color: !isSeeker
                                                          ? colors.onPrimary
                                                          : colors.onSurface,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Pemilik Kos',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: !isSeeker
                                                            ? colors.onPrimary
                                                            : colors.onSurface,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField( // Diubah ke TextFormField agar bisa divalidasi
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Email tidak boleh kosong';
                                        }
                                        return null;
                                      },
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

                                    Text(
                                      'Kata sandi',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField( // Diubah ke TextFormField agar bisa divalidasi
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Kata sandi tidak boleh kosong';
                                        }
                                        return null;
                                      },
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

                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: FilledButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () => _loginAsRole(_selectedRole),
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          isSeeker
                                              ? 'Masuk sebagai Pencari Kost'
                                              : 'Masuk sebagai Pemilik Kos',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

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