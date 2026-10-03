import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/booking_model.dart';
import '../models/kost_model.dart';
import '../models/review_model.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';
import 'form_item_screen.dart';

class DetailScreen extends StatelessWidget {
  final Kost item;

  const DetailScreen({super.key, required this.item});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kos ini?'),
        content: Text('“${item.title}” akan dihapus dari daftar kos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppState>().deleteKost(item.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final appState = context.read<AppState>();
    final userName = appState.currentUser.name;
    String duration = '3 Bulan';
    String startDate = 'Segera (Bulan ini)';

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajukan Sewa / Booking Kos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
              ),
              const Divider(height: 24),
              const Text('Durasi Sewa', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: duration,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                items: ['1 Bulan', '3 Bulan', '6 Bulan', '1 Tahun']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setStateSheet(() => duration = val!),
              ),
              const SizedBox(height: 16),
              const Text('Rencana Masuk', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: startDate,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
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
                        kostId: item.id,
                        kostTitle: item.title,
                        kostImageUrl: item.imageUrl,
                        userName: userName,
                        durationMonths: duration,
                        startDate: startDate,
                        status: 'Menunggu Konfirmasi',
                        createdAt: DateTime.now(),
                      ),
                    );
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengajuan sewa berhasil dikirim ke pemilik kos!')),
                    );
                  },
                  child: const Text('Kirim Pengajuan Sewa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalculatorDialog(BuildContext context) {
    int months = 3;
    bool includeExtraAc = false;
    bool includeLaundry = false;

    // Parse base price
    final numericPrice = int.tryParse(item.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 800000;

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
                        Text('$months Bulan', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  onChanged: (val) => setStateSheet(() => includeExtraAc = val!),
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('Paket Laundry (+Rp 100rb/bln)'),
                  value: includeLaundry,
                  onChanged: (val) => setStateSheet(() => includeLaundry = val!),
                  dense: true,
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Estimasi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
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

  void _showAddReviewDialog(BuildContext context) {
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
              const Text('Rating (Bintang):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      starIndex <= rating ? Icons.star_rounded : Icons.star_border_rounded,
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Komentar / Pengalaman:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
                    kostId: item.id,
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Membaca state aplikasi dan role pengguna saat ini
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    final isOwner = currentUser?.role == UserRole.pemilikKost;
    final isFavorite = appState.favoriteKosts.any((k) => k.id == item.id);
    final reviews = appState.getReviewsForKost(item.id);

    final categories = appState.categories;
    final category = categories.where((cat) => cat.id == item.categoryId);
    final categoryName = category.isEmpty ? 'Kos pilihan' : category.first.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail kos'),
        actions: [
          // Tombol Share
          IconButton(
            tooltip: 'Bagikan kos',
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share('Cek kos ${item.title} di ${item.location} - Harga: ${item.price}. Temukan di Finding Kost!');
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
                  builder: (_) => FormItemScreen(itemToEdit: item),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Hapus kos',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _showDeleteDialog(context),
            ),
          ]
          // Jika Pencari Kost: Tampilkan tombol Simpan/Favorit
          else ...[
            IconButton(
              tooltip: isFavorite ? 'Hapus dari tersimpan' : 'Simpan ke favorit',
              icon: Icon(
                isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isFavorite ? colors.primary : null,
              ),
              onPressed: () {
                appState.toggleFavorite(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Dihapus dari kos tersimpan'
                          : 'Disimpan ke kos tersimpan',
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
                imageUrl: item.imageUrl,
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
            ],
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      item.rating.toStringAsFixed(1),
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
                  item.location,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                        item.price,
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
                  onPressed: () => _showCalculatorDialog(context),
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
          // TOMBOL AJUKAN SEWA / BOOKING
          if (!isOwner) ...[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () => _showBookingDialog(context),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Ajukan Sewa / Booking Kamar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
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
            item.description,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 22),
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
                onPressed: () => _showAddReviewDialog(context),
                icon: const Icon(Icons.rate_review_outlined, size: 16),
                label: const Text('Beri Ulasan'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Belum ada ulasan untuk kos ini.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            )
          else
            for (final review in reviews)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 0,
                color: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(review.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(review.comment, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
