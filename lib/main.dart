import 'package:flutter/material.dart';

void main() {
  runApp(const FindingKostApp());
}

class FindingKostApp extends StatefulWidget {
  const FindingKostApp({super.key});

  @override
  State<FindingKostApp> createState() => _FindingKostAppState();
}

class _FindingKostAppState extends State<FindingKostApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      seedColor: const Color(0xFF557C62),
      brightness: brightness,
      surface: brightness == Brightness.light
          ? const Color(0xFFF7F8F5)
          : const Color(0xFF151A17),
    );
    return _themeFor(colors);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finding Kost',
      themeMode: _themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: LoginScreen(onToggleTheme: _toggleTheme),
    );
  }
}

ThemeData _themeFor(ColorScheme colors) => ThemeData(
  useMaterial3: true,
  colorScheme: colors,
  scaffoldBackgroundColor: colors.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: colors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.45),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primary, width: 1.4),
    ),
  ),
  cardTheme: CardThemeData(
    color: colors.surfaceContainerLow,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

// ==========================================
// 1. LAYAR LOGIN
// ==========================================

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            onPressed: onToggleTheme,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.home_work_rounded, size: 80, color: colors.primary),

                const SizedBox(height: 16),

                Text(
                  'Finding Kost',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Temukan tempat kos impianmu dengan mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 36),

                // EMAIL
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email anda',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // PASSWORD
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // TOMBOL MASUK
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(onToggleTheme: onToggleTheme),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                // LINK DAFTAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? '),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

// ==========================================
// 2. LAYAR REGISTER
// ==========================================

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Baru'), elevation: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Daftar Akun',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Lengkapi data di bawah ini untuk mendaftar',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // NAMA LENGKAP
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // DAFTAR
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran Berhasil! Silakan Login.'),
                  ),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Daftar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. LAYAR BERANDA
// ==========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(onToggleTheme: onToggleTheme),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finding Kost',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,

        actions: [
          IconButton(
            tooltip: 'Chat dengan asisten',
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ChatbotScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Buat pengaduan',
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ComplaintScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: Theme.of(context).brightness == Brightness.dark
                ? 'Gunakan mode terang'
                : 'Gunakan mode gelap',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: onToggleTheme,
          ),

          // LOGOUT
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),

      // ==========================================
      // BAGIAN INI BISA DI-SCROLL
      // ==========================================
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // SEARCH
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari nama kos atau lokasi...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
          ),

          const SizedBox(height: 12),

          // ==========================================
          // TOMBOL LOKASI + FILTER
          // ==========================================
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.my_location, size: 18),
                  label: const Text('Search by Location'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined, size: 18),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ==========================================
          // JUDUL
          // ==========================================
          const Text(
            'Rekomendasi Kos Terdekat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // ==========================================
          // KOS 1
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1560185008-b033106af5c3?w=800',
            nama: 'Kos Bahagia Medan',
            lokasi: 'Kec. Medan Baru • 500m dari lokasi',
            harga: 'Rp 850.000 / bulan',
            rating: '4.8',
          ),

          // ==========================================
          // KOS 2
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
            nama: 'Kost Putri Harmoni',
            lokasi: 'Kec. Medan Selayang • 1.2km dari lokasi',
            harga: 'Rp 750.000 / bulan',
            rating: '4.7',
          ),

          // ==========================================
          // KOS 3
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800',
            nama: 'Kost Nyaman Residence',
            lokasi: 'Kec. Medan Kota • 1.5km dari lokasi',
            harga: 'Rp 950.000 / bulan',
            rating: '4.9',
          ),

          // ==========================================
          // KOS 4
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
            nama: 'Kost Mahasiswa Medan',
            lokasi: 'Kec. Medan Petisah • 2km dari lokasi',
            harga: 'Rp 700.000 / bulan',
            rating: '4.6',
          ),

          // ==========================================
          // KOS 5
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800',
            nama: 'Kost Sejahtera',
            lokasi: 'Kec. Medan Denai • 2.5km dari lokasi',
            harga: 'Rp 800.000 / bulan',
            rating: '4.7',
          ),

          // ==========================================
          // KOS 6
          // ==========================================
          KostCard(
            imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
            nama: 'Kost Nyaman Bersama',
            lokasi: 'Kec. Medan Amplas • 3km dari lokasi',
            harga: 'Rp 900.000 / bulan',
            rating: '4.8',
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Tidak ada kos lainnya',
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Halo! Aku bisa bantu soal harga, lokasi, dan cara mencari kos.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedMessage]) {
    final message = (suggestedMessage ?? _messageController.text).trim();
    if (message.isEmpty) return;
    final query = message.toLowerCase();
    final response = query.contains('harga') || query.contains('budget')
        ? 'Pilihan kos yang tersedia mulai dari Rp700.000 per bulan. Kamu bisa memakai filter harga di halaman utama.'
        : query.contains('lokasi') ||
              query.contains('medan') ||
              query.contains('dekat')
        ? 'Ada pilihan di Medan Baru, Medan Selayang, dan Medan Kota. Cari nama area di kolom pencarian.'
        : query.contains('lapor') || query.contains('pengaduan')
        ? 'Buka menu pengaduan untuk mengirim kendala atau masukan.'
        : 'Aku bisa bantu soal kisaran harga, area kos di Medan, atau cara mengirim pengaduan.';

    setState(() {
      _messages
        ..add(_ChatMessage(text: message, isUser: true))
        ..add(_ChatMessage(text: response, isUser: false));
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Asisten Finding Kost')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('chat-input'),
                    controller: _messageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const Key('chat-send'),
                  tooltip: 'Kirim pesan',
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String _category = 'Fasilitas kos';
  final List<String> _submittedReports = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submittedReports.insert(
        0,
        '$_category: ${_descriptionController.text.trim()}',
      );
      _descriptionController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaduan dicatat selama sesi ini.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan pengaduan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Ada yang perlu\ndiperbaiki?',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Ceritakan kendala atau masukanmu kepada kami.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Fasilitas kos',
                      child: Text('Fasilitas kos'),
                    ),
                    DropdownMenuItem(
                      value: 'Informasi kos',
                      child: Text('Informasi kos'),
                    ),
                    DropdownMenuItem(
                      value: 'Kendala aplikasi',
                      child: Text('Kendala aplikasi'),
                    ),
                    DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                  ],
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('report-description'),
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Detail pengaduan',
                    hintText: 'Jelaskan apa yang terjadi...',
                  ),
                  validator: (value) => value == null || value.trim().length < 8
                      ? 'Isi minimal 8 karakter.'
                      : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    key: const Key('report-submit'),
                    onPressed: _submitReport,
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Kirim pengaduan'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Laporan sesi ini',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_submittedReports.isEmpty)
            Text(
              'Belum ada laporan.',
              style: TextStyle(color: colors.onSurfaceVariant),
            )
          else
            for (final report in _submittedReports)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.check_circle_outline,
                  color: colors.primary,
                ),
                title: Text(
                  report,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. WIDGET KARTU KOS
// ==========================================

class KostCard extends StatelessWidget {
  final String imageUrl;
  final String nama;
  final String lokasi;
  final String harga;
  final String rating;

  const KostCard({
    super.key,
    required this.imageUrl,
    required this.nama,
    required this.lokasi,
    required this.harga,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      elevation: 2,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // FOTO KOS
          // ==========================================

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),

            child: Image.network(
              imageUrl,

              height: 170,
              width: double.infinity,

              fit: BoxFit.cover,

              // Jika gambar gagal dimuat
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 170,
                  color: Colors.grey[300],

                  child: const Center(
                    child: Icon(Icons.home_work, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // INFORMASI KOS
          // ==========================================
          Padding(
            padding: const EdgeInsets.all(12.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // NAMA KOS + RATING
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      child: Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),

                        Text(
                          ' $rating',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // LOKASI
                Text(
                  lokasi,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 8),

                // HARGA
                Text(
                  harga,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),

                // TOMBOL DETAIL
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Lihat Detail'),
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
