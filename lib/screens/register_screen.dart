import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole _selectedRole = UserRole.pencariKost;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('user_password', _passwordController.text.trim());

    if (_selectedRole == UserRole.pemilikKost) {
      await prefs.setString('user_phone', _phoneController.text.trim());
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan masuk dengan akun baru.'),
          backgroundColor: Color(0xFF2D6A4F),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = context.watch<AppState>().isDarkMode;

    final headerTextColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    const greenThemeColor = Color(0xFF2D6A4F);
    final textFieldFillColor = isDarkMode ? colors.surfaceContainer : const Color(0xFFE5E0D8);

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
              Color(0xFFC2D4C8),
              Color(0xFFD9CFBF),
              Color(0xFFE3DCCE),
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
                            shadowColor: Colors.black.withOpacity(0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: isDarkMode
                                ? colors.surfaceContainer
                                : const Color(0xFFF2EBE1),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 48,
                                        child: SegmentedButton<UserRole>(
                                          style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(25),
                                              ),
                                            ),
                                            backgroundColor:
                                            WidgetStateProperty.resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.selected)) {
                                                  return isDarkMode
                                                      ? colors.primary
                                                      : greenThemeColor;
                                                }
                                                return Colors.transparent;
                                              },
                                            ),
                                            foregroundColor:
                                            WidgetStateProperty.resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.selected)) {
                                                  return Colors.white;
                                                }
                                                return isDarkMode
                                                    ? Colors.white70
                                                    : const Color(0xFF333333);
                                              },
                                            ),
                                            textStyle: WidgetStateProperty.all(
                                              const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          segments: const [
                                            ButtonSegment<UserRole>(
                                              value: UserRole.pencariKost,
                                              label: Text('Pencari Kost'),
                                              icon: Icon(Icons.home_rounded,
                                                  size: 18),
                                            ),
                                            ButtonSegment<UserRole>(
                                              value: UserRole.pemilikKost,
                                              label: Text('Pemilik Kost'),
                                              icon: Icon(Icons.home_outlined,
                                                  size: 18),
                                            ),
                                          ],
                                          selected: {_selectedRole},
                                          onSelectionChanged: (newSelection) {
                                            setState(() {
                                              _selectedRole = newSelection.first;
                                            });
                                          },
                                        ),
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
                                        filled: true,
                                        fillColor: textFieldFillColor,
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
                                        filled: true,
                                        fillColor: textFieldFillColor,
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
                                    if (_selectedRole == UserRole.pemilikKost) ...[
                                      TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(fontSize: 14),
                                        validator: (value) =>
                                        value == null || value.trim().isEmpty
                                            ? 'Nomor HP tidak boleh kosong'
                                            : null,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: textFieldFillColor,
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
                                        filled: true,
                                        fillColor: textFieldFillColor,
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
                                        filled: true,
                                        fillColor: textFieldFillColor,
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
                                        onPressed: _handleRegister,
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
                                        child: const Text(
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