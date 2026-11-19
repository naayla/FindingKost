import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/booking_model.dart';
import '../models/kost_model.dart';
import '../models/message_model.dart';
import '../models/review_model.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';
import 'form_item_screen.dart';

class DetailScreen extends StatelessWidget {
  final Kost item;

  const DetailScreen({super.key, required this.item});

  void _showDeleteDialog(BuildContext context, Kost currentItem) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kos ini?'),
        content: Text('“${currentItem.title}” akan dihapus dari daftar kos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppState>().deleteKost(currentItem.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context, Kost currentItem) {
    final appState = context.read<AppState>();
    final userName = appState.currentUser.name;
    final userEmail = appState.currentUser.email;
    String duration = '3 Bulan';
    String startDate = 'Segera (Bulan ini)';
    String seekerGender = 'Pria';
    String seekerMarriageStatus = 'Belum Menikah';
    String occupantsCount = '1 Orang';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ajukan Sewa / Booking Kamar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  currentItem.title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700),
                ),
                const Divider(height: 24),
                const Text('Gender / Jenis Kelamin',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: seekerGender,
                  decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['Pria', 'Wanita']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setStateSheet(() => seekerGender = val!),
                ),
                const SizedBox(height: 14),
                const Text('Status Pernikahan',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: seekerMarriageStatus,
                  decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['Belum Menikah', 'Pasutri / Menikah']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (val) =>
                      setStateSheet(() => seekerMarriageStatus = val!),
                ),
                const SizedBox(height: 14),
                const Text('Jumlah Penghuni / Orang',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: occupantsCount,
                  decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['1 Orang', '2 Orang', '3 Orang']
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (val) =>
                      setStateSheet(() => occupantsCount = val!),
                ),
                const SizedBox(height: 14),
                const Text('Durasi Sewa',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: duration,
                  decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['1 Bulan', '3 Bulan', '6 Bulan', '1 Tahun']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) => setStateSheet(() => duration = val!),
                ),
                const SizedBox(height: 14),
                const Text('Rencana Masuk',
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: startDate,
                  decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  items: ['Segera (Bulan ini)', 'Bulan Depan', '2 Bulan Lagi']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setStateSheet(() => startDate = val!),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      appState.addBooking(
                        BookingModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          kostId: currentItem.id,
                          kostTitle: currentItem.title,
                          kostImageUrl: currentItem.imageUrl,
                          userName: userName,
                          userEmail: userEmail,
                          seekerGender: seekerGender,
                          seekerMarriageStatus: seekerMarriageStatus,
                          occupantsCount: occupantsCount,
                          durationMonths: duration,
                          startDate: startDate,
                          status: 'Menunggu Konfirmasi',
                          createdAt: DateTime.now(),
                        ),
                      );
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Pengajuan sewa beserta data preferensi terkirim ke pemilik!')),
                      );
                    },
                    child: const Text('Kirim Pengajuan Sewa'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCalculatorDialog(BuildContext context, Kost currentItem) {
    int months = 3;
    bool includeExtraAc = false;
    bool includeLaundry = false;

    final numericPrice = int.tryParse(
        currentItem.price.replaceAll(RegExp(r'[^0-9]'), '')) ??
        800000;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setStateSheet) {
          int extra = 0;
          if (includeExtraAc) extra += 150000;
          if (includeLaundry) extra += 100000;
          final total = (numericPrice * months) + (extra * months);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kalkulator Estimasi Biaya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Durasi Sewa:'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (months > 1) setStateSheet(() => months--);
                          },
                        ),
                        Text('$months Bulan',
                            style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setStateSheet(() => months++),
                        ),
                      ],
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('Tambahan Listrik/AC (+Rp 150rb/bln)'),
                  value: includeExtraAc,
                  onChanged: (val) =>
                      setStateSheet(() => includeExtraAc = val!),
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('Paket Laundry (+Rp 100rb/bln)'),
                  value: includeLaundry,
                  onChanged: (val) =>
                      setStateSheet(() => includeLaundry = val!),
                  dense: true,
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Estimasi:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, Kost currentItem) {
    final appState = context.read<AppState>();
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Beri Ulasan & Rating'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rating (Bintang):',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setStateDialog(() {
                        rating = starIndex.toDouble();
                      });
                    },
                  );
                }),
              ),
              Center(
                child: Text(
                  '${rating.toInt()} / 5 Bintang',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Komentar / Pengalaman:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan pengalaman tinggal di sini...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (commentController.text.trim().isEmpty) return;
                appState.addReview(
                  ReviewModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    kostId: currentItem.id,
                    userName: appState.currentUser.name,
                    rating: rating,
                    comment: commentController.text.trim(),
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ulasan berhasil ditambahkan!')),
                );
              },
              child: const Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatDialog(BuildContext context, Kost currentItem) {
    final appState = context.read<AppState>();
    final user = appState.currentUser;
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Chat Pemilik: ${currentItem.ownerName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kos: ${currentItem.title}',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Email Anda: ${user.email}',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Tulis pesan / tanyakan ketersediaan kamar...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (messageController.text.trim().isEmpty) return;
              appState.sendOwnerMessage(
                MessageModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  kostId: currentItem.id,
                  kostTitle: currentItem.title,
                  seekerName: user.name,
                  seekerEmail: user.email,
                  message: messageController.text.trim(),
                  createdAt: DateTime.now(),
                  isRead: false,
                ),
              );
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pesan terkirim ke pemilik kos!')),
              );
            },
            child: const Text('Kirim Pesan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appState = context.watch<AppState>();

// Ambil data kos terbaru dari AppState agar perubahan jumlah kamar langsung terupdate
    final currentItem = appState.items.firstWhere(
          (k) => k.id == item.id,
      orElse: () => item,
    );

    final currentUser = appState.currentUser;
    final isOwner = currentUser.role == UserRole.pemilikKost;
    final isFavorite = appState.favoriteKosts.any((k) => k.id == currentItem.id);
    final reviews = appState.getReviewsForKost(currentItem.id);

    final categories = appState.categories;
    final category =
    categories.where((cat) => cat.id == currentItem.categoryId);
    final categoryName = category.isEmpty ? 'Kos pilihan' : category.first.name;

    final int roomsLeft = currentItem.safeAvailableRooms;
    final bool hasEmptyRooms = currentItem.isAvailable && roomsLeft > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail kos'),
        actions: [
// Tombol Share
          IconButton(
            tooltip: 'Bagikan kos',
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share(
                  'Cek kos ${currentItem.title} di ${currentItem.location} - Harga: ${currentItem.price}. Temukan di Finding Kost!');
            },
          ),
// Jika Pemilik Kost: Tampilkan tombol Edit & Hapus
          if (isOwner) ...[
            IconButton(
              tooltip: 'Edit informasi kos',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => FormItemScreen(itemToEdit: currentItem),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Hapus kos',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _showDeleteDialog(context, currentItem),
            ),
          ]
// Jika Pencari Kost: Tampilkan tombol Simpan/Favorit
          else ...[
            IconButton(
              tooltip: isFavorite ? 'Hapus dari tersimpan' : 'Simpan ke favorit',
              icon: Icon(
                isFavorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isFavorite ? colors.primary : null,
              ),
              onPressed: () async {
                final saved = await appState.toggleFavorite(currentItem.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saved
                          ? isFavorite
                                ? 'Dihapus dari kos tersimpan'
                                : 'Disimpan ke kos tersimpan'
                          : 'Perubahan favorit gagal disimpan',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          Stack(
            children: [
              KostImage(
                imageUrl: currentItem.imageUrl,
                height: 260,
                borderRadius: 24,
              ),
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
// Badge Status Ketersediaan Kamar di atas gambar
              Positioned(
                right: 14,
                top: 14,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: hasEmptyRooms
                        ? const Color(0xFF2D6A4F)
                        : Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasEmptyRooms ? 'Sisa $roomsLeft Kamar' : 'Penuh',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Text(
                  currentItem.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 17,
                      color: colors.onTertiaryContainer,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      currentItem.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: colors.onTertiaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: colors.secondary,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  currentItem.location,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

// KARTU INFORMASI KETERSEDIAAN & JUMLAH KAMAR KOSONG
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: hasEmptyRooms
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hasEmptyRooms
                    ? Colors.green.withValues(alpha: 0.35)
                    : Colors.red.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: hasEmptyRooms
                        ? Colors.green.withValues(alpha: 0.18)
                        : Colors.red.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasEmptyRooms
                        ? Icons.meeting_room_rounded
                        : Icons.no_meeting_room_rounded,
                    color: hasEmptyRooms
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasEmptyRooms
                            ? 'Kamar Tersedia'
                            : 'Kamar Sudah Penuh',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: hasEmptyRooms
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasEmptyRooms
                            ? 'Masih ada $roomsLeft kamar kosong yang siap ditempati.'
                            : 'Saat ini seluruh kamar sudah terisi (0 kamar kosong).',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasEmptyRooms
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    hasEmptyRooms ? '$roomsLeft Kosong' : 'Penuh',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.onPrimaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.payments_outlined,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga sewa',
                        style: TextStyle(
                          color: colors.onPrimaryContainer.withValues(
                            alpha: 0.74,
                          ),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        currentItem.price,
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showCalculatorDialog(context, currentItem),
                  icon: const Icon(Icons.calculate_outlined, size: 16),
                  label: const Text('Kalkulator'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.surface,
                    foregroundColor: colors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

// TOMBOL AJUKAN SEWA / BOOKING & CHAT PEMILIK
          if (!isOwner) ...[
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: hasEmptyRooms
                          ? () => _showBookingDialog(context, currentItem)
                          : null,
                      icon: Icon(
                        hasEmptyRooms
                            ? Icons.bookmark_add_outlined
                            : Icons.block_rounded,
                        size: 18,
                      ),
                      label: Text(
                        hasEmptyRooms ? 'Ajukan Sewa' : 'Kamar Penuh',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _showChatDialog(context, currentItem),
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          size: 18),
                      label: const Text('Chat Pemilik',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
          ],

          Text(
            'Tentang tempat ini',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            currentItem.description,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 18),

// FASILITAS KOS
          if (currentItem.facilities.isNotEmpty) ...[
            Text(
              'Fasilitas tersedia',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentItem.facilities
                  .map(
                    (facility) => Chip(
                  avatar: Icon(Icons.check_circle_outline_rounded,
                      size: 16, color: colors.primary),
                  label:
                  Text(facility, style: const TextStyle(fontSize: 12)),
                  backgroundColor: colors.surfaceContainerLow,
                  side: BorderSide.none,
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 22),
          ],

// ULASAN & RATING SECTION
          Row(
            children: [
              Text(
                'Ulasan Penghuni (${reviews.length})',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showAddReviewDialog(context, currentItem),
                icon: const Icon(Icons.rate_review_outlined, size: 16),
                label: const Text('Beri Ulasan'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Belum ada ulasan untuk kos ini.',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            )
          else
            for (final review in reviews)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 0,
                color: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(review.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(review.rating.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(review.comment,
                          style: TextStyle(
                              fontSize: 12, color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}