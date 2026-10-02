import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final _emailController = TextEditingController(text: 'nayla@example.com');
  final _passwordController = TextEditingController(text: '12345678');
  UserRole _selectedRole = UserRole.pencariKost;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginAsRole(UserRole role) {
    final appState = context.read<AppState>();
    if (role == UserRole.pemilikKost) {
      appState.setCurrentUser(
        UserModel(
          id: 'user_owner_1',
          name: 'Ibu Hj. Aminah',
          email: 'owner.aminah@example.com',
          phone: '+62 813 9876 5432',
          role: UserRole.pemilikKost,
          institutionOrBusiness: 'Pemilik Kos Harmoni & Grand Residence',
        ),
      );
    } else {
      appState.setCurrentUser(
        UserModel(
          id: 'user_seeker_1',
          name: 'Nayla Syifa Tanjung',
          email: 'nayla@example.com',
          phone: '+62 812 3456 7890',
          role: UserRole.pencariKost,
          institutionOrBusiness: 'Universitas Sumatera Utara',
        ),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = context.watch<AppState>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: const Key('theme-toggle'),
            tooltip: 'Ganti tema',
            onPressed: context.read<AppState>().toggleDarkMode,
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo()),
                  const SizedBox(height: 32),
                  Text(
                    'Selamat datang kembali',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih peranmu untuk masuk ke aplikasi Finding Kost.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Role Choice Segmented Control
                  SegmentedButton<UserRole>(
                    segments: const [
                      ButtonSegment<UserRole>(
                        value: UserRole.pencariKost,
                        label: Text('Pencari Kost'),
                        icon: Icon(Icons.person_search_rounded),
                      ),
                      ButtonSegment<UserRole>(
                        value: UserRole.pemilikKost,
                        label: Text('Pemilik Kost'),
                        icon: Icon(Icons.real_estate_agent_rounded),
                      ),
                    ],
                    selected: {_selectedRole},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _selectedRole = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      labelText: 'Email',
                      hintText: 'nama@email.com',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      labelText: 'Kata sandi',
                    ),
                  ),
                  const SizedBox(height: 20),

                  FilledButton(
                    onPressed: () => _loginAsRole(_selectedRole),
                    child: Text('Masuk sebagai ${_selectedRole.displayName}'),
                  ),
                  const SizedBox(height: 16),

                  // Quick Demo Login Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coba Masuk Cepat (Demo):',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _loginAsRole(UserRole.pencariKost),
                                icon: const Icon(Icons.person_outline, size: 16),
                                label: const Text('Pencari Kost'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _loginAsRole(UserRole.pemilikKost),
                                icon: const Icon(Icons.home_work_outlined, size: 16),
                                label: const Text('Pemilik Kost'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: const Text('Daftar sekarang'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
