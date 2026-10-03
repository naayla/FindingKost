import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kost_model.dart';
import '../providers/app_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/kost_image.dart';
import 'chatbot_screen.dart';
import 'complaint_screen.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;

  // --- FILTER & SORT STATE ---
  String _sortBy = 'rekomendasi'; // 'rekomendasi', 'harga_asc', 'harga_desc', 'rating_desc'
  double _minPrice = 0;
  double _maxPrice = 3500000;
  List<String> _selectedFacilities = [];
  bool _onlyAvailable = false;
  double _minRating = 0;

  static const double _defaultMaxPriceLimit = 3500000;

  final List<String> _popularFacilities = [
    'WiFi',
    'AC',
    'Kamar Mandi Dalam',
    'Kasur',
    'Lemari',
    'Parkir',
    'Dapur',
    'Water Heater',
    'CCTV',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _parsePrice(String priceStr) {
    final clean = priceStr.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(clean) ?? 0;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_sortBy != 'rekomendasi') count++;
    if (_minPrice > 0 || _maxPrice < _defaultMaxPriceLimit) count++;
    if (_selectedFacilities.isNotEmpty) count += _selectedFacilities.length;
    if (_onlyAvailable) count++;
    if (_minRating > 0) count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      _sortBy = 'rekomendasi';
      _minPrice = 0;
      _maxPrice = _defaultMaxPriceLimit;
      _selectedFacilities = [];
      _onlyAvailable = false;
      _minRating = 0;
    });
  }

  String _formatRupiah(double value) {
    if (value >= 1000000) {
      double jt = value / 1000000;
      return 'Rp ${jt.toStringAsFixed(jt.truncateToDouble() == jt ? 0 : 1)} Jt';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).toInt()}rb';
    }
    return 'Rp ${value.toInt()}';
  }

  void _showFilterBottomSheet(BuildContext context) {
    // Local copy of filter states for dialog interaction
    String tempSortBy = _sortBy;
    RangeValues tempPriceRange = RangeValues(_minPrice, _maxPrice);
    List<String> tempFacilities = List.from(_selectedFacilities);
    bool tempOnlyAvailable = _onlyAvailable;
    double tempMinRating = _minRating;

    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final activeTempCount = (tempSortBy != 'rekomendasi' ? 1 : 0) +
                (tempPriceRange.start > 0 || tempPriceRange.end < _defaultMaxPriceLimit ? 1 : 0) +
                tempFacilities.length +
                (tempOnlyAvailable ? 1 : 0) +
                (tempMinRating > 0 ? 1 : 0);

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.onSurfaceVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sheet Header
                      Row(
                        children: [
                          Text(
                            'Filter & Urutkan',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          if (activeTempCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$activeTempCount aktif',
                                style: TextStyle(
                                  color: colors.onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempSortBy = 'rekomendasi';
                                tempPriceRange = const RangeValues(0, _defaultMaxPriceLimit);
                                tempFacilities = [];
                                tempOnlyAvailable = false;
                                tempMinRating = 0;
                              });
                            },
                            child: const Text('Riset Semua'),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Scrollable Filter Sections
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // 1. URUTKAN (SORT BY)
                            _FilterSectionTitle(
                              title: 'Urutkan Berdasarkan',
                              icon: Icons.sort_rounded,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _SortChip(
                                  label: 'Rekomendasi',
                                  selected: tempSortBy == 'rekomendasi',
                                  onSelected: () => setModalState(() => tempSortBy = 'rekomendasi'),
                                ),
                                _SortChip(
                                  label: 'Harga Termurah',
                                  icon: Icons.arrow_downward_rounded,
                                  selected: tempSortBy == 'harga_asc',
                                  onSelected: () => setModalState(() => tempSortBy = 'harga_asc'),
                                ),
                                _SortChip(
                                  label: 'Harga Termahal',
                                  icon: Icons.arrow_upward_rounded,
                                  selected: tempSortBy == 'harga_desc',
                                  onSelected: () => setModalState(() => tempSortBy = 'harga_desc'),
                                ),
                                _SortChip(
                                  label: 'Rating Tertinggi',
                                  icon: Icons.star_rounded,
                                  selected: tempSortBy == 'rating_desc',
                                  onSelected: () => setModalState(() => tempSortBy = 'rating_desc'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // 2. RENTANG HARGA
                            _FilterSectionTitle(
                              title: 'Rentang Harga Per Bulan',
                              icon: Icons.payments_outlined,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatRupiah(tempPriceRange.start),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: colors.primary,
                                  ),
                                ),
                                Text(
                                  tempPriceRange.end >= _defaultMaxPriceLimit
                                      ? '${_formatRupiah(tempPriceRange.end)}+'
                                      : _formatRupiah(tempPriceRange.end),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: tempPriceRange,
                              min: 0,
                              max: _defaultMaxPriceLimit,
                              divisions: 35,
                              labels: RangeLabels(
                                _formatRupiah(tempPriceRange.start),
                                _formatRupiah(tempPriceRange.end),
                              ),
                              onChanged: (values) {
                                setModalState(() {
                                  tempPriceRange = values;
                                });
                              },
                            ),
                            // Quick Price Presets
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ActionChip(
                                  label: const Text('< 1 Juta'),
                                  onPressed: () => setModalState(() {
                                    tempPriceRange = const RangeValues(0, 1000000);
                                  }),
                                ),
                                ActionChip(
                                  label: const Text('1 Jt - 2 Jt'),
                                  onPressed: () => setModalState(() {
                                    tempPriceRange = const RangeValues(1000000, 2000000);
                                  }),
                                ),
                                ActionChip(
                                  label: const Text('> 2 Juta'),
                                  onPressed: () => setModalState(() {
                                    tempPriceRange = const RangeValues(2000000, _defaultMaxPriceLimit);
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // 3. STATUS KETERSEDIAAN
                            _FilterSectionTitle(
                              title: 'Ketersediaan',
                              icon: Icons.event_available_rounded,
                            ),
                            const SizedBox(height: 6),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Hanya kos yang masih tersedia',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              value: tempOnlyAvailable,
                              onChanged: (val) => setModalState(() => tempOnlyAvailable = val),
                            ),
                            const SizedBox(height: 18),

                            // 4. MINIMUM RATING
                            _FilterSectionTitle(
                              title: 'Minimum Rating',
                              icon: Icons.star_outline_rounded,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: [
                                for (final r in [0.0, 4.0, 4.5, 4.8])
                                  FilterChip(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (r > 0) ...[
                                          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFC78B33)),
                                          const SizedBox(width: 4),
                                        ],
                                        Text(r == 0 ? 'Semua Rating' : '≥ ${r.toStringAsFixed(1)}'),
                                      ],
                                    ),
                                    selected: tempMinRating == r,
                                    onSelected: (_) => setModalState(() => tempMinRating = r),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // 5. FASILITAS KOST
                            _FilterSectionTitle(
                              title: 'Fasilitas Kos',
                              icon: Icons.single_bed_outlined,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final facility in _popularFacilities)
                                  FilterChip(
                                    label: Text(facility),
                                    selected: tempFacilities.contains(facility),
                                    onSelected: (selected) {
                                      setModalState(() {
                                        if (selected) {
                                          tempFacilities.add(facility);
                                        } else {
                                          tempFacilities.remove(facility);
                                        }
                                      });
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),

                      // Apply Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: () {
                              setState(() {
                                _sortBy = tempSortBy;
                                _minPrice = tempPriceRange.start;
                                _maxPrice = tempPriceRange.end;
                                _selectedFacilities = tempFacilities;
                                _onlyAvailable = tempOnlyAvailable;
                                _minRating = tempMinRating;
                              });
                              Navigator.pop(ctx);
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: Text(
                              activeTempCount > 0
                                  ? 'Terapkan Filter ($activeTempCount)'
                                  : 'Terapkan Filter',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
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
    final categories = appState.categories;

    // Filter Logic
    final filteredKost = appState.items.where((kost) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = kost.title.toLowerCase().contains(query) ||
          kost.location.toLowerCase().contains(query);
      final matchesCategory = _selectedCategoryId == null ||
          kost.categoryId == _selectedCategoryId;

      final priceVal = _parsePrice(kost.price);
      final matchesPrice = priceVal >= _minPrice && priceVal <= _maxPrice;

      final matchesAvailability = !_onlyAvailable || kost.isAvailable;

      final matchesRating = kost.rating >= _minRating;

      final matchesFacilities = _selectedFacilities.isEmpty ||
          _selectedFacilities.every((fac) {
            return kost.facilities.any((f) => f.toLowerCase().contains(fac.toLowerCase()));
          });

      return matchesQuery &&
          matchesCategory &&
          matchesPrice &&
          matchesAvailability &&
          matchesRating &&
          matchesFacilities;
    }).toList();

    // Sort Logic
    if (_sortBy == 'harga_asc') {
      filteredKost.sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
    } else if (_sortBy == 'harga_desc') {
      filteredKost.sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
    } else if (_sortBy == 'rating_desc') {
      filteredKost.sort((a, b) => b.rating.compareTo(a.rating));
    }

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
                  // APP HEADER
                  Row(
                    children: [
                      const AppLogo(compact: true),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              'RUANG NYAMANMU MENANTI',
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
                        tooltip: 'Pengaturan',
                        icon: Icons.settings_outlined,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
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

                  // HERO BANNER
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.primary,
                          colors.primary.withValues(alpha: 0.82),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -18,
                          top: -28,
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
                              'TEMUKAN TEMPAT PULANG',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: colors.onPrimary
                                        .withValues(alpha: 0.78),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.3,
                                  ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              'Ruang nyaman,\nawal cerita baru.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: colors.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    height: 1.14,
                                    letterSpacing: -0.7,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Temukan kos yang cocok dengan ritme hidupmu.',
                              style: TextStyle(
                                color: colors.onPrimary.withValues(alpha: 0.82),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _HeroStat(
                                  value: '${appState.items.length}+',
                                  label: 'Pilihan kos',
                                  color: colors.onPrimary,
                                ),
                                const SizedBox(width: 24),
                                _HeroStat(
                                  value: '${categories.length}',
                                  label: 'Kategori',
                                  color: colors.onPrimary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // SEARCH FIELD
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
                      hintText: 'Cari nama kos atau lokasi',
                    ),
                  ),
                  const SizedBox(height: 18),

                  // CATEGORIES HEADER
                  Text(
                    'Jelajahi kategori',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),

                  // CATEGORY CHIPS
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

                  // SECTION HEADER WITH FILTER BUTTON
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Pilihan untukmu'
                                  : 'Hasil pencarian',
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
                      // Interactive Filter Button
                      InkWell(
                        onTap: () => _showFilterBottomSheet(context),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeFilterCount > 0
                                ? colors.primaryContainer
                                : colors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _activeFilterCount > 0
                                  ? colors.primary
                                  : colors.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                color: _activeFilterCount > 0
                                    ? colors.onPrimaryContainer
                                    : colors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: _activeFilterCount > 0
                                      ? colors.onPrimaryContainer
                                      : colors.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                              if (_activeFilterCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$_activeFilterCount',
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ACTIVE FILTERS CHIPS BAR
                  if (_activeFilterCount > 0) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 34,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (_sortBy != 'rekomendasi')
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                label: Text(
                                  _sortBy == 'harga_asc'
                                      ? 'Urut: Termurah'
                                      : _sortBy == 'harga_desc'
                                          ? 'Urut: Termahal'
                                          : 'Urut: Rating',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                                onDeleted: () => setState(() => _sortBy = 'rekomendasi'),
                              ),
                            ),
                          if (_minPrice > 0 || _maxPrice < _defaultMaxPriceLimit)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                label: Text(
                                  '${_formatRupiah(_minPrice)} - ${_formatRupiah(_maxPrice)}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                                onDeleted: () => setState(() {
                                  _minPrice = 0;
                                  _maxPrice = _defaultMaxPriceLimit;
                                }),
                              ),
                            ),
                          if (_onlyAvailable)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                label: const Text(
                                  'Hanya Tersedia',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                                onDeleted: () => setState(() => _onlyAvailable = false),
                              ),
                            ),
                          if (_minRating > 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                label: Text(
                                  'Rating ≥ ${_minRating.toStringAsFixed(1)}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                                onDeleted: () => setState(() => _minRating = 0),
                              ),
                            ),
                          for (final fac in _selectedFacilities)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InputChip(
                                label: Text(
                                  fac,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                                onDeleted: () => setState(() => _selectedFacilities.remove(fac)),
                              ),
                            ),
                          ActionChip(
                            label: const Text('Hapus Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.red)),
                            onPressed: _resetFilters,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // KOST LIST OR EMPTY STATE
                  if (filteredKost.isEmpty)
                    _EmptySearch(
                      query: _searchQuery,
                      hasActiveFilters: _activeFilterCount > 0,
                      onResetFilters: _resetFilters,
                    )
                  else
                    for (final kost in filteredKost)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _KostCard(
                          kost: kost,
                          category: categoryName(kost),
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
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
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
        fixedSize: const Size(42, 42),
      ),
      icon: Icon(icon, size: 19),
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
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12),
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
    required this.onTap,
  });

  final Kost kost;
  final String category;
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
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 7,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFC78B33),
                              size: 16,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              kost.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!kost.isAvailable)
                    Positioned(
                      left: 11,
                      bottom: 11,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Penuh / Tidak Tersedia',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 13, 5, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kost.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
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
                    const SizedBox(height: 10),
                    // Facility preview tags
                    if (kost.facilities.isNotEmpty) ...[
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: kost.facilities.take(3).map((fac) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              fac,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
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
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: colors.primary,
                          size: 20,
                        ),
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
  const _EmptySearch({
    required this.query,
    required this.hasActiveFilters,
    required this.onResetFilters,
  });

  final String query;
  final bool hasActiveFilters;
  final VoidCallback onResetFilters;

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
            query.isEmpty ? 'Belum ada kos yang cocok' : 'Kos belum ditemukan',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            hasActiveFilters
                ? 'Tidak ada kos yang memenuhi kombinasi filter dan pencarian Anda.'
                : 'Coba kata kunci atau kategori lainnya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onResetFilters,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Semua Filter'),
            ),
          ],
        ],
      ),
    );
  }
}
