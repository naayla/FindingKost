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
  late double _rating;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _titleController = TextEditingController(text: item?.title ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _priceController = TextEditingController(text: item?.price ?? '');
    _imageController = TextEditingController(text: item?.imageUrl ?? '');
    _rating = item?.rating ?? 4.5;
    _selectedCategoryId = item?.categoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final appState = context.read<AppState>();
    final categories = appState.categories;
    final categoryId = categories.any((category) => category.id == _selectedCategoryId)
        ? _selectedCategoryId
        : categories.firstOrNull?.id;
    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan kategori terlebih dahulu.'),
        ),
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
    );

    if (isEditing) {
      appState.updateKost(widget.itemToEdit!.id, newKost);
    } else {
      appState.addKost(newKost);
    }
    Navigator.pop(context);
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
        title: Text(isEditing ? 'Edit informasi kos' : 'Tambah kos'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Text(
              isEditing ? 'Perbarui informasi' : 'Ceritakan tentang kos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lengkapi detail agar pencari kos dapat membandingkan dengan mudah.',
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
                labelText: 'Nama kos',
                hintText: 'Contoh: Kost Harmoni',
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
                labelText: 'Kategori kos',
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
                labelText: 'Lokasi',
                hintText: 'Kecamatan, patokan, atau jarak ke kampus',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Lokasi kos wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _priceController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Harga sewa',
                hintText: 'Contoh: Rp 850.000 / bulan',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Harga sewa wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 19),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: colors.tertiary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Penilaian',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        _rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 40,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _imageController,
              keyboardType: TextInputType.url,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Tautan foto (opsional)',
                hintText: 'https://...',
                prefixIcon: Icon(Icons.image_outlined),
              ),
              validator: (value) {
                final url = value?.trim() ?? '';
                if (url.isEmpty) return null;
                final uri = Uri.tryParse(url);
                if (uri == null ||
                    !uri.hasAuthority ||
                    (uri.scheme != 'http' && uri.scheme != 'https')) {
                  return 'Masukkan tautan gambar yang valid.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saveForm,
              icon: Icon(isEditing ? Icons.save_outlined : Icons.add_rounded),
              label: Text(isEditing ? 'Simpan perubahan' : 'Simpan kos'),
            ),
          ],
        ),
      ),
    );
  }
}
