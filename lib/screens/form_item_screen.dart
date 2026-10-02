import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kost_model.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';

class FormItemScreen extends StatefulWidget {
  final Kost? itemToEdit;

  const FormItemScreen({super.key, this.itemToEdit});

  @override
  State<FormItemScreen> createState() => _FormItemScreenState();
}

class _FormItemScreenState extends State<FormItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _ownerPhoneController;
  late final TextEditingController _descriptionController;

  late double _rating;
  late bool _isAvailable;
  String? _selectedCategoryId;
  late List<String> _selectedFacilities;

  static const List<String> _availableFacilityOptions = [
    'WiFi',
    'AC',
    'Kamar Mandi Dalam',
    'Kasur',
    'Lemari',
    'Parkir',
    'TV',
    'Dapur',
    'CCTV',
    'Water Heater',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _titleController = TextEditingController(text: item?.title ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _priceController = TextEditingController(text: item?.price ?? '');
    _imageController = TextEditingController(text: item?.imageUrl ?? '');
    _latController = TextEditingController(
      text: (item?.latitude ?? 3.5651).toString(),
    );
    _lngController = TextEditingController(
      text: (item?.longitude ?? 98.6538).toString(),
    );
    _ownerNameController = TextEditingController(
      text: item?.ownerName ?? 'H. Rahmad S.T.',
    );
    _ownerPhoneController = TextEditingController(
      text: item?.ownerPhone ?? '+6281234567890',
    );
    _descriptionController = TextEditingController(
      text: item?.description ??
          'Kos bersih, aman, dan nyaman berlokasi strategis dekat fasilitas umum.',
    );

    _rating = item?.rating ?? 4.5;
    _isAvailable = item?.isAvailable ?? true;
    _selectedCategoryId = item?.categoryId;
    _selectedFacilities = List.from(
      item?.facilities ?? ['WiFi', 'Kamar Mandi Dalam', 'AC', 'Kasur'],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final appState = context.read<AppState>();
    final categories = appState.categories;
    final categoryId =
        categories.any((category) => category.id == _selectedCategoryId)
            ? _selectedCategoryId
            : categories.firstOrNull?.id;
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan kategori terlebih dahulu.')),
      );
      return;
    }

    final isEditing = widget.itemToEdit != null;
    final newKost = Kost(
      id: isEditing
          ? widget.itemToEdit!.id
          : DateTime.now().microsecondsSinceEpoch.toString(),
      categoryId: categoryId,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      price: _priceController.text.trim(),
      rating: _rating,
      imageUrl: _imageController.text.trim().isNotEmpty
          ? _imageController.text.trim()
          : 'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=1400&q=88',
      latitude: double.tryParse(_latController.text) ?? 3.5651,
      longitude: double.tryParse(_lngController.text) ?? 98.6538,
      facilities: _selectedFacilities,
      ownerId: appState.currentUser.id,
      ownerName: _ownerNameController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
      description: _descriptionController.text.trim(),
      isAvailable: _isAvailable,
    );

    if (isEditing) {
      appState.updateKost(widget.itemToEdit!.id, newKost);
    } else {
      appState.addKost(newKost);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing ? 'Informasi kos berhasil diperbarui!' : 'Kos berhasil ditambahkan!',
        ),
      ),
    );

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final categories = appState.categories;
    final isEditing = widget.itemToEdit != null;

    final selectedCategory = categories.any(
      (category) => category.id == _selectedCategoryId,
    )
        ? _selectedCategoryId
        : categories.firstOrNull?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Informasi Kos' : 'Tambah Katalog Kos'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Text(
              isEditing ? 'Perbarui informasi' : 'Tambah Katalog Kos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lengkapi detail properti agar pencari kos dapat menemukan kos milikmu dengan mudah.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            if (_imageController.text.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: KostImage(
                  imageUrl: _imageController.text.trim(),
                  height: 180,
                  borderRadius: 20,
                ),
              ),

            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nama Kos',
                hintText: 'Contoh: Kos Bahagia Medan Baru',
                prefixIcon: Icon(Icons.home_work_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama kos wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori Kos',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategoryId = value),
              validator: (value) =>
                  value == null ? 'Pilih kategori kos.' : null,
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _locationController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Alamat / Lokasi Singkat',
                hintText: 'Contoh: Jl. Dr. Mansyur, Kec. Medan Baru',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Lokasi kos wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 14),

            // Google Maps Direct Coordinates
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: '3.5651',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: '98.6538',
                      prefixIcon: Icon(Icons.pin_drop_outlined),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga Sewa',
                hintText: 'Contoh: Rp 850.000 / bulan',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Harga sewa wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemilik Kos',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _ownerPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor WA / Telepon Pemilik',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Tambahan',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 18),

            // Facilities selection chips
            Text(
              'Pilih Fasilitas Kos',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _availableFacilityOptions.map((fac) {
                final isSelected = _selectedFacilities.contains(fac);
                return FilterChip(
                  label: Text(fac),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedFacilities.add(fac);
                      } else {
                        _selectedFacilities.remove(fac);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Rating & Status Availability
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Status Kamar Tersedia'),
              subtitle: Text(
                _isAvailable
                    ? 'Kos dapat dipesan oleh pencari kos'
                    : 'Kos ditandai penuh',
              ),
              value: _isAvailable,
              onChanged: (val) => setState(() => _isAvailable = val),
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _imageController,
              keyboardType: TextInputType.url,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Tautan Foto Kos (Opsional)',
                hintText: 'https://...',
                prefixIcon: Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saveForm,
              icon: Icon(isEditing ? Icons.save_outlined : Icons.add_rounded),
              label: Text(isEditing ? 'Simpan Perubahan' : 'Simpan Katalog Kos'),
            ),
          ],
        ),
      ),
    );
  }
}
