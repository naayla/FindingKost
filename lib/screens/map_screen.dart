import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/kost_model.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';
import 'detail_screen.dart';

class MapScreen extends StatefulWidget {
  final Kost? initialSelectedKost;

  const MapScreen({super.key, this.initialSelectedKost});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Kost? _selectedKost;
  String? _selectedCategoryId;

  static const LatLng _defaultMedanCenter = LatLng(3.5850, 98.6700);

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedKost != null) {
      _selectedKost = widget.initialSelectedKost;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_selectedKost != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_selectedKost!.latitude, _selectedKost!.longitude),
          15.0,
        ),
      );
    }
  }

  Set<Marker> _buildMarkers(List<Kost> kostList) {
    final markers = <Marker>{};
    for (final kost in kostList) {
      final isSelected = _selectedKost?.id == kost.id;
      markers.add(
        Marker(
          markerId: MarkerId(kost.id),
          position: LatLng(kost.latitude, kost.longitude),
          infoWindow: InfoWindow(
            title: kost.title,
            snippet: '${kost.price} • Rating ${kost.rating}',
          ),
          icon: isSelected
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          onTap: () {
            setState(() {
              _selectedKost = kost;
            });
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(kost.latitude, kost.longitude),
                15.0,
              ),
            );
          },
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final categories = appState.categories;

    final filteredKostList = appState.items.where((kost) {
      final matchesCategory = _selectedCategoryId == null ||
          kost.categoryId == _selectedCategoryId;
      return matchesCategory;
    }).toList();

    final markers = _buildMarkers(filteredKostList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Sebaran Kos Direct'),
        actions: [
          IconButton(
            tooltip: 'Reset Tampilan Peta',
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {
              setState(() {
                _selectedKost = null;
              });
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(_defaultMedanCenter, 12.8),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Native Interactive Google Maps view
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedKost != null
                  ? LatLng(_selectedKost!.latitude, _selectedKost!.longitude)
                  : _defaultMedanCenter,
              zoom: _selectedKost != null ? 15.0 : 12.8,
            ),
            onMapCreated: _onMapCreated,
            markers: markers,
            myLocationEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
            onTap: (_) {
              setState(() {
                _selectedKost = null;
              });
            },
          ),

          // Top Floating Category Filter Bar
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: const Text('Semua Area'),
                      selected: _selectedCategoryId == null,
                      onSelected: (_) => setState(() => _selectedCategoryId = null),
                      showCheckmark: false,
                      selectedColor: colors.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _selectedCategoryId == null
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                      backgroundColor: colors.surface.withValues(alpha: 0.92),
                      elevation: 2,
                    ),
                  ),
                  for (final category in categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(category.name),
                        selected: _selectedCategoryId == category.id,
                        onSelected: (_) =>
                            setState(() => _selectedCategoryId = category.id),
                        showCheckmark: false,
                        selectedColor: colors.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _selectedCategoryId == category.id
                              ? colors.onPrimary
                              : colors.onSurface,
                        ),
                        backgroundColor: colors.surface.withValues(alpha: 0.92),
                        elevation: 2,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Top Info Indicator
          Positioned(
            top: 64,
            left: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: colors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${filteredKostList.length} titik kos di Medan',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Floating Selected Item Preview Card
          if (_selectedKost != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _KostMapCard(
                kost: _selectedKost!,
                onClose: () => setState(() => _selectedKost = null),
                onTapDetail: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => DetailScreen(item: _selectedKost!),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _KostMapCard extends StatelessWidget {
  final Kost kost;
  final VoidCallback onClose;
  final VoidCallback onTapDetail;

  const _KostMapCard({
    required this.kost,
    required this.onClose,
    required this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 8,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                KostImage(
                  imageUrl: kost.imageUrl,
                  width: 85,
                  height: 85,
                  borderRadius: 14,
                ),
                const SizedBox(width: 12),
                Expanded(
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              kost.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
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
                          const Spacer(),
                          Text(
                            kost.price,
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTapDetail,
                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                    label: const Text('Lihat Detail Kos'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
