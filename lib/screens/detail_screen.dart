import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kost_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Membaca state aplikasi dan role pengguna saat ini
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    final isOwner = currentUser?.role == UserRole.pemilikKost;
    final isFavorite = appState.favoriteKosts.any((k) => k.id == item.id);

    final categories = appState.categories;
    final category = categories.where((cat) => cat.id == item.categoryId);
    final categoryName = category.isEmpty ? 'Kos pilihan' : category.first.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail kos'),
        actions: [
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
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Tentang tempat ini',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Tempat tinggal ini terdaftar dalam kategori $categoryName dengan '
                'penilaian ${item.rating.toStringAsFixed(1)} dari 5. '
                'Gunakan informasi harga dan lokasi sebagai panduan awal, lalu '
                'pastikan ketersediaan serta fasilitas langsung kepada pengelola.',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: colors.primary),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    'Informasi fasilitas dan ketersediaan dapat berubah. '
                        'Konfirmasi kembali sebelum melakukan pemesanan.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                      height: 1.5,
                    ),
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