import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/kost_model.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';
import 'form_item_screen.dart';
import 'map_screen.dart';

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

  Future<void> _contactOwner(BuildContext context, String phone, String title) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final whatsappUrl = Uri.parse('https://wa.me/$cleanPhone?text=Halo,%20saya%20tertarik%20dengan%20kos%20"$title"%20di%20Finding%20Kost.');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        _showContactFallbackDialog(context, phone);
      }
    } catch (_) {
      if (!context.mounted) return;
      _showContactFallbackDialog(context, phone);
    }
  }

  void _showContactFallbackDialog(BuildContext context, String phone) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kontak Pemilik Kos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Pemilik: ${item.ownerName}'),
            const SizedBox(height: 8),
            SelectableText(
              'Nomor HP / WA: $phone',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  IconData _facilityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi_rounded;
    if (lower.contains('ac')) return Icons.ac_unit_rounded;
    if (lower.contains('mandi') || lower.contains('toilet')) return Icons.shower_rounded;
    if (lower.contains('kasur') || lower.contains('bed')) return Icons.bed_rounded;
    if (lower.contains('lemari')) return Icons.door_sliding_outlined;
    if (lower.contains('parkir')) return Icons.directions_car_rounded;
    if (lower.contains('tv')) return Icons.tv_rounded;
    if (lower.contains('heater') || lower.contains('hangat')) return Icons.water_drop_rounded;
    if (lower.contains('dapur')) return Icons.soup_kitchen_rounded;
    if (lower.contains('cctv') || lower.contains('security')) return Icons.security_rounded;
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appState = context.watch<AppState>();
    final isOwner = appState.isOwner;
    final categories = appState.categories;
    final category = categories.where((c) => c.id == item.categoryId);
    final categoryName = category.isEmpty ? 'Kos pilihan' : category.first.name;
    final isFavorite = appState.isFavorite(item.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kos'),
        actions: [
          if (!isOwner)
            IconButton(
              tooltip: isFavorite ? 'Hapus dari tersimpan' : 'Simpan ke favorit',
              icon: Icon(
                isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: isFavorite ? colors.primary : colors.onSurface,
              ),
              onPressed: () => appState.toggleFavorite(item.id),
            ),
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
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
        children: [
          // Hero Image Header with badges
          Stack(
            children: [
              KostImage(
                imageUrl: item.imageUrl,
                height: 250,
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
              Positioned(
                right: 14,
                top: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: (item.isAvailable ? Colors.green : Colors.red)
                        .withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.isAvailable ? 'Status: Tersedia' : 'Status: Penuh',
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

          // Title & Rating
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

          // Location
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
          const SizedBox(height: 18),

          // Price Card
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
                        'Harga Sewa',
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
          const SizedBox(height: 22),

          // Facilities Section
          Text(
            'Fasilitas Kos',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.facilities.map((fac) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_facilityIcon(fac), size: 16, color: colors.primary),
                    const SizedBox(width: 6),
                    Text(
                      fac,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),

          // Google Maps Direct Preview Box
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lokasi Google Maps Direct',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => MapScreen(initialSelectedKost: item),
                    ),
                  );
                },
                icon: const Icon(Icons.fullscreen_rounded, size: 18),
                label: const Text('Buka di Peta'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 180,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(item.latitude, item.longitude),
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(item.id),
                        position: LatLng(item.latitude, item.longitude),
                        infoWindow: InfoWindow(title: item.title),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => MapScreen(initialSelectedKost: item),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Owner Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  child: Icon(Icons.person_rounded, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.ownerName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pemilik / Pengelola Kos',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Hubungi WA',
                  icon: const Icon(Icons.chat_rounded, size: 20),
                  onPressed: () => _contactOwner(context, item.ownerPhone, item.title),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Description
          Text(
            'Deskripsi Tempat',
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
              height: 1.6,
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isOwner) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    appState.toggleKostAvailability(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          item.isAvailable
                              ? 'Status diubah ke Penuh'
                              : 'Status diubah ke Tersedia',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: Text(
                    item.isAvailable ? 'Ubah ke Penuh' : 'Ubah ke Tersedia',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => FormItemScreen(itemToEdit: item),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit Informasi'),
                ),
              ),
            ] else ...[
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _contactOwner(context, item.ownerPhone, item.title),
                  icon: const Icon(Icons.chat_bubble_rounded),
                  label: const Text('Hubungi Pemilik (WhatsApp)'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
