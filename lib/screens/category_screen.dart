import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/app_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  void _showCategoryDialog(BuildContext context, [Category? category]) {
    final formKey = GlobalKey<FormState>();
    String name = category?.name ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: name,
            decoration: const InputDecoration(labelText: 'Nama Kategori'),
            validator: (val) =>
            val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
            onSaved: (val) => name = val!,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final appState = Provider.of<AppState>(context, listen: false);

                if (category == null) {
                  appState.addCategory(
                    Category(
                      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      iconName: 'folder',
                    ),
                  );
                } else {
                  appState.updateCategory(
                    category.id,
                    Category(
                      id: category.id,
                      name: name,
                      iconName: category.iconName,
                    ),
                  );
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final categories = appState.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final itemCount =
              appState.items.where((item) => item.categoryId == cat.id).length;

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.folder, color: Colors.teal),
            ),
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('$itemCount item terikat'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showCategoryDialog(context, cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    appState.deleteCategory(cat.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}