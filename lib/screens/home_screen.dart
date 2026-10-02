import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kost_model.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/kost_image.dart';
import 'chatbot_screen.dart';
import 'complaint_screen.dart';
import 'detail_screen.dart';
import 'form_item_screen.dart';
import 'login_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu bisa masuk kembali kapan saja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final isOwner = appState.isOwner;
    final categories = appState.categories;

    final displayItems = isOwner ? appState.ownerItems : appState.items;

    final filteredKost = displayItems.where((kost) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = kost.title.toLowerCase().contains(query) ||
          kost.location.toLowerCase().contains(query);
      final matchesCategory = _selectedCategoryId == null ||
          kost.categoryId == _selectedCategoryId;
      return matchesQuery && matchesCategory;
    }).toList();

    String categoryName(Kost kost) {
      for (final category in categories) {
        if (category.id == kost.categoryId) return category.name;
      }
      return 'Kos pilihan';
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // --- HEADER ---
                  Row(
                    children: [
                      const AppLogo(compact: true),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Finding Kost',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.4,
                                      ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOwner
                                        ? colors.secondaryContainer
                                        : colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    appState.currentRole.displayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isOwner
                                          ? colors.onSecondaryContainer
                                          : colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              isOwner
                                  ? 'DASHBOARD KELOLA KATALOG'
                                  : 'RUANG NYAMANMU MENANTI',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _HeaderAction(
                        tooltip: 'Chat dengan asisten',
                        icon: Icons.chat_bubble_outline_rounded,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const ChatbotScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _HeaderAction(
                        tooltip: 'Buat pengaduan',
                        icon: Icons.support_agent_rounded,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const ComplaintScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _HeaderAction(
                        tooltip: 'Keluar',
                        icon: Icons.logout_rounded,
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // --- HERO BANNER (PEMILIK VS PENCARI) ---
                  if (isOwner)
                    _OwnerDashboardCard(
                      totalKost: displayItems.length,
                      availableCount:
                          displayItems.where((k) => k.isAvailable).length,
                      categoriesCount: categories.length,
                      onAddPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const FormItemScreen(),
                          ),
                        );
                      },
                    )
                  else
                    _SeekerHeroCard(
                      totalKost: appState.items.length,
                      categoriesCount: categories.length,
                      onOpenMap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const MapScreen(),
                        ),
                      ),
                    ),

                  const SizedBox(height: 22),

                  // --- SEARCH BAR ---
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            ),
                      hintText: isOwner
                          ? 'Cari di katalog kos milikmu...'
                          : 'Cari nama kos, area, atau kecamatan di Medan',
                    ),
                  ),
                  const SizedBox(height: 18),

                  // --- CATEGORY BAR WITH GOOGLE MAPS DIRECT BUTTON ---
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Jelajahi kategori',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const MapScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.map_rounded, size: 18),
                        label: const Text('Peta Direct'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 42,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _CategoryChip(
                            label: 'Semua',
                            selected: _selectedCategoryId == null,
                            onTap: () =>
                                setState(() => _selectedCategoryId = null),
                          ),
                        ),
                        for (final category in categories)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _CategoryChip(
                              label: category.name,
                              selected: _selectedCategoryId == category.id,
                              onTap: () => setState(
                                () => _selectedCategoryId = category.id,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // --- LIST HEADER ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOwner
                                  ? 'Katalog Kos Saya'
                                  : (_searchQuery.isEmpty
                                      ? 'Pilihan untukmu'
                                      : 'Hasil pencarian'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${filteredKost.length} tempat tinggal ditemukan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      if (isOwner)
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const FormItemScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Tambah'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // --- LIST KOST ITEMS ---
                  if (filteredKost.isEmpty)
                    _EmptySearch(query: _searchQuery)
                  else
                    for (final kost in filteredKost)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _KostCard(
                          kost: kost,
                          category: categoryName(kost),
                          isOwner: isOwner,
                          isFavorite: appState.isFavorite(kost.id),
                          onToggleFavorite: () =>
                              appState.toggleFavorite(kost.id),
                          onToggleAvailability: () =>
                              appState.toggleKostAvailability(kost.id),
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => FormItemScreen(itemToEdit: kost),
                            ),
                          ),
                          onDelete: () => _confirmDeleteKost(context, kost),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => DetailScreen(item: kost),
                            ),
                          ),
                        ),
                      ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteKost(BuildContext context, Kost kost) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kos dari Katalog?'),
        content: Text('“${kost.title}” akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppState>().deleteKost(kost.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kos berhasil dihapus.')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: colors.surfaceContainerLow,
        foregroundColor: colors.onSurfaceVariant,
        fixedSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

class _SeekerHeroCard extends StatelessWidget {
  final int totalKost;
  final int categoriesCount;
  final VoidCallback onOpenMap;

  const _SeekerHeroCard({
    required this.totalKost,
    required this.categoriesCount,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -24,
            child: Icon(
              Icons.home_work_rounded,
              size: 145,
              color: colors.onPrimary.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PENCARI KOST',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onPrimary.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ruang nyaman,\nawal cerita baru.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1.14,
                      letterSpacing: -0.7,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Temukan kos impianmu secara langsung lewat Peta Google Maps.',
                style: TextStyle(
                  color: colors.onPrimary.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _HeroStat(
                    value: '$totalKost+',
                    label: 'Pilihan kos',
                    color: colors.onPrimary,
                  ),
                  const SizedBox(width: 20),
                  _HeroStat(
                    value: '$categoriesCount',
                    label: 'Kategori',
                    color: colors.onPrimary,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: onOpenMap,
                    icon: const Icon(Icons.map_rounded, size: 16),
                    label: const Text('Buka Peta'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.onPrimary,
                      foregroundColor: colors.primary,
                      minimumSize: const Size(0, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OwnerDashboardCard extends StatelessWidget {
  final int totalKost;
  final int availableCount;
  final int categoriesCount;
  final VoidCallback onAddPressed;

  const _OwnerDashboardCard({
    required this.totalKost,
    required this.availableCount,
    required this.categoriesCount,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.secondary,
            colors.secondary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PANEL PEMILIK KOST',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSecondary.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
              ),
              const Spacer(),
              Icon(
                Icons.admin_panel_settings_rounded,
                color: colors.onSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola Properti & Katalog',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelola ketersediaan kamar dan posting iklan kos baru.',
            style: TextStyle(
              color: colors.onSecondary.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroStat(
                value: '$totalKost',
                label: 'Total Kos',
                color: colors.onSecondary,
              ),
              const SizedBox(width: 16),
              _HeroStat(
                value: '$availableCount',
                label: 'Tersedia',
                color: colors.onSecondary,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah Kos'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.onSecondary,
                  foregroundColor: colors.secondary,
                  minimumSize: const Size(0, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.82), fontSize: 11),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      selectedColor: Theme.of(context).colorScheme.primary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

class _KostCard extends StatelessWidget {
  const _KostCard({
    required this.kost,
    required this.category,
    required this.isOwner,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onToggleAvailability,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  final Kost kost;
  final String category;
  final bool isOwner;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleAvailability;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  KostImage(
                    imageUrl: kost.imageUrl,
                    height: 190,
                    borderRadius: 17,
                  ),
                  Positioned(
                    left: 11,
                    top: 11,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 11,
                    top: 11,
                    child: isOwner
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              color: (kost.isAvailable ? Colors.green : Colors.red)
                                  .withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 6,
                              ),
                              child: Text(
                                kost.isAvailable ? 'Tersedia' : 'Penuh',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: colors.surface.withValues(alpha: 0.92),
                            radius: 18,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                isFavorite
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: isFavorite ? colors.primary : colors.onSurface,
                                size: 20,
                              ),
                              onPressed: onToggleFavorite,
                            ),
                          ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 12, 5, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kost.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFC78B33),
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              kost.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            kost.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kost.price,
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        // Action Buttons based on Role
                        if (isOwner) ...[
                          OutlinedButton.icon(
                            onPressed: onToggleAvailability,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              minimumSize: const Size(0, 32),
                            ),
                            icon: Icon(
                              kost.isAvailable
                                  ? Icons.event_busy_rounded
                                  : Icons.event_available_rounded,
                              size: 14,
                            ),
                            label: Text(
                              kost.isAvailable ? 'Set Penuh' : 'Set Tersedia',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            tooltip: 'Edit Kos',
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: onEdit,
                          ),
                          IconButton(
                            tooltip: 'Hapus Kos',
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: colors.error,
                            ),
                            onPressed: onDelete,
                          ),
                        ] else ...[
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: colors.primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: colors.primary),
          const SizedBox(height: 12),
          Text(
            query.isEmpty ? 'Belum ada kos di kategori ini' : 'Kos belum ditemukan',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            'Coba kata kunci atau kategori lainnya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
