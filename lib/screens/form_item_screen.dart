import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kost_model.dart';
import '../providers/app_state.dart';

class FormItemScreen extends StatefulWidget {
  final Kost? itemToEdit;

  const FormItemScreen({super.key, this.itemToEdit});

  @override
  State<FormItemScreen> createState() => _FormItemScreenState();
}

class _FormItemScreenState extends State<FormItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _location;
  late String _price;
  late double _rating;
  late String _imageUrl;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _title = widget.itemToEdit?.title ?? '';
    _location = widget.itemToEdit?.location ?? '';
    _price = widget.itemToEdit?.price ?? '';
    _rating = widget.itemToEdit?.rating ?? 4.5;
    _imageUrl = widget.itemToEdit?.imageUrl ?? '';
    _selectedCategoryId = widget.itemToEdit?.categoryId;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final appState = Provider.of<AppState>(context, listen: false);

      final isEditing = widget.itemToEdit != null;
      final newKost = Kost(
        id: isEditing ? widget.itemToEdit!.id : DateTime.now().toString(),
        categoryId: _selectedCategoryId ?? 'cat_1',
        title: _title,
        location: _location,
        price: _price,
        rating: _rating,
        imageUrl: _imageUrl.isNotEmpty
            ? _imageUrl
            : 'https://images.unsplash.com/photo-1554995207-c18c203602cb?q=80&w=600',
      );

      if (isEditing) {
        appState.updateKost(widget.itemToEdit!.id, newKost);
      } else {
        appState.addKost(newKost);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final categories = appState.categories;
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Kos' : 'Tambah Kos Baru'),
        backgroundColor: const Color(0xFFF9F9FB),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Judul Kos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  // Menggunakan initialValue untuk menghindari peringatan 'value' is deprecated
                  initialValue: _selectedCategoryId ?? (categories.isNotEmpty ? categories.first.id : null),
                  decoration: const InputDecoration(
                    labelText: 'Kategori Kos',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _location,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Lokasi tidak boleh kosong' : null,
                  onSaved: (value) => _location = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _price,
                  decoration: const InputDecoration(
                    labelText: 'Harga (contoh: Rp 850.000 / bulan)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Harga tidak boleh kosong' : null,
                  onSaved: (value) => _price = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _imageUrl = value ?? '',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6750A4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveForm,
                    child: Text(
                      isEditing ? 'Simpan Perubahan' : 'Tambah Item',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}