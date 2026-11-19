import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';

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
  final _institutionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole _selectedRole = UserRole.pencariKost;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _institutionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Buat akun baru di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Update nama display user di Firebase jika diperlukan
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      // 3. Simpan cadangan data pendukung ke SharedPreferences (opsional)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_phone', _phoneController.text.trim());
      await prefs.setString(
        'user_role',
        _selectedRole == UserRole.pemilikKost ? 'pemilik' : 'pencari',
      );
      await prefs.setString(
        'user_institution',
        _institutionController.text.trim().isNotEmpty
            ? _institutionController.text.trim()
            : (_selectedRole == UserRole.pemilikKost ? 'Pemilik Kos Mandiri' : ''),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan masuk dengan akun baru.'),
          backgroundColor: Color(0xFF2D6A4F),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan saat mendaftar.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah terdaftar. Gunakan email lain atau masuk.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Kata sandi terlalu lemah.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = context.watch<AppState>().isDarkMode;

    final headerTextColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    const greenThemeColor = Color(0xFF2D6A4F);

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
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: headerTextColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
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
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: greenThemeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Daftar akun',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: headerTextColor,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: isDarkMode ? 1 : 2,
                            shadowColor: Colors.black.withValues(alpha: 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: isDarkMode
                                ? colors.surfaceContainer
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
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
                                                  color: _selectedRole ==
                                                      UserRole.pencariKost
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
                                                      color: _selectedRole ==
                                                          UserRole
                                                              .pencariKost
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
                                                        color: _selectedRole ==
                                                            UserRole
                                                                .pencariKost
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
                                                  color: _selectedRole ==
                                                      UserRole.pemilikKost
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
                                                      color: _selectedRole ==
                                                          UserRole
                                                              .pemilikKost
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
                                                        color: _selectedRole ==
                                                            UserRole
                                                                .pemilikKost
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
                                    TextFormField(
                                      controller: _nameController,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) =>
                                      value == null || value.trim().isEmpty
                                          ? 'Nama tidak boleh kosong'
                                          : null,
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal: 16,
                                        ),
                                        prefixIcon: const Icon(
                                            Icons.person_outline_rounded,
                                            size: 20),
                                        hintText: 'Nama lengkap',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Email tidak boleh kosong';
                                        }
                                        if (!value.contains('@')) {
                                          return 'Email tidak valid';
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
                                            Icons.mail_outline_rounded,
                                            size: 20),
                                        hintText: 'Masukkan email',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (_selectedRole == UserRole.pencariKost) ...[
                                      TextFormField(
                                        controller: _institutionController,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 16,
                                          ),
                                          prefixIcon: const Icon(
                                              Icons.school_outlined,
                                              size: 20),
                                          hintText: 'Institusi / Kampus (Opsional)',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ] else ...[
                                      TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(fontSize: 14),
                                        validator: (value) =>
                                        value == null || value.trim().isEmpty
                                            ? 'Nomor WhatsApp tidak boleh kosong'
                                            : null,
                                        decoration: InputDecoration(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 16,
                                          ),
                                          prefixIcon: const Icon(
                                              Icons.phone_outlined,
                                              size: 20),
                                          hintText: 'Nomor WhatsApp / Kontak',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Kata sandi tidak boleh kosong';
                                        }
                                        if (value.length < 8) {
                                          return 'Minimal 8 karakter';
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
                                        hintText: 'Masukkan kata sandi',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Konfirmasi kata sandi tidak boleh kosong';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Kata sandi tidak cocok';
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
                                            _obscureConfirmPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                        hintText: 'Konfirmasi kata sandi',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                      EdgeInsets.only(left: 12, top: 6),
                                      child: Text(
                                        'Gunakan minimal 8 karakter.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF5F6265),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: FilledButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _handleRegister,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: isDarkMode
                                              ? colors.primary
                                              : greenThemeColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                            : const Text(
                                          'Daftar Sekarang',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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