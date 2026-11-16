import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import 'activity_screen.dart';
import 'main_navigation_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _savedName = '';
  String _savedEmail = '';
  String _savedPhone = '';
  String _savedInstitution = '';

  @override
  void initState() {
    super.initState();
    _loadRegisteredData();
  }

  Future<void> _loadRegisteredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('user_name') ?? '';
      _savedEmail = prefs.getString('user_email') ?? '';
      _savedPhone = prefs.getString('user_phone') ?? '';
      _savedInstitution = prefs.getString('user_institution') ?? '';
    });
  }



  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2 && names[0].isNotEmpty && names[1].isNotEmpty) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty && names[0].isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    final isOwner = currentUser?.role == UserRole.pemilikKost;

    final userName = _savedName.isNotEmpty
        ? _savedName
        : (currentUser?.name ?? '');

    final userEmail = _savedEmail.isNotEmpty
        ? _savedEmail
        : (currentUser?.email ?? '');

    final userPhone = _savedPhone.isNotEmpty
        ? _savedPhone
        : (currentUser?.phone ?? '');

    final userCampus = _savedInstitution.isNotEmpty
        ? _savedInstitution
        : (currentUser?.institutionOrBusiness ?? '');

    final initials = userName.isNotEmpty ? _getInitials(userName) : '?';
    final displayName = userName.isNotEmpty ? userName : 'Belum Masuk / Tamu';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.thumb_up_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF386A58),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOwner ? 'Akun Pemilik Kost' : 'Akun Pencari Kost',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                        label: const Text('Edit Profil', style: TextStyle(color: Colors.white, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          final newRole = isOwner ? UserRole.pencariKost : UserRole.pemilikKost;
                          appState.setRole(newRole);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                          );
                        },
                        icon: const Icon(Icons.swap_horiz, size: 14, color: Color(0xFF2D5545)),
                        label: Text(
                          isOwner ? 'Mode Pencari' : 'Mode Pemilik',
                          style: const TextStyle(color: Color(0xFF2D5545), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_border_rounded, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Kos Tersimpan', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.category_outlined, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Kategori Kos', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (!isOwner) ...[
              const SizedBox(height: 20),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.history_edu_rounded, color: colors.primary),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riwayat Booking & Aktivitas',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Lihat status pengajuan sewa dan log aktivitas',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              'Informasi Akun',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.mail_outline_rounded,
              title: 'Email Registered',
              subtitle: userEmail.isEmpty ? '-' : userEmail,
            ),
            if (isOwner) ...[
              if (userPhone.isNotEmpty && userPhone != '-') ...[
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Icons.phone_outlined,
                  title: 'Nomor WhatsApp / Kontak',
                  subtitle: userPhone,
                ),
              ],
            ] else ...[
              if (userCampus.isNotEmpty && userCampus != '-') ...[
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Icons.school_outlined,
                  title: 'Institusi / Kampus',
                  subtitle: userCampus,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8DC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2D5545), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: subtitle == '-' ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}