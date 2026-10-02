import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/app_state.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  Future<void> _showCategoryDialog(
    BuildContext context, [
    Category? category,
  ]) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: category?.name ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(category == null ? 'Tambah kategori' : 'Edit kategori'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nama kategori',
              hintText: 'Contoh: Kos dekat kampus',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama kategori wajib diisi.'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !context.mounted) return;

    final appState = context.read<AppState>();
    if (category == null) {
      appState.addCategory(
        Category(
          id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
          name: result,
          iconName: 'folder',
        ),
      );
    } else {
      appState.updateCategory(
        category.id,
        Category(id: category.id, name: result, iconName: category.iconName),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Category category,
    int itemCount,
  ) async {
    if (itemCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Kategori masih digunakan'),
          content: Text(
            'Pindahkan $itemCount kos dari kategori "${category.name}" '
            'sebelum menghapusnya.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kategori?'),
        content: Text('Kategori "${category.name}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (shouldDelete == true && context.mounted) {
      context.read<AppState>().deleteCategory(category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final categories = appState.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori kos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Kategori baru'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          Text(
            'Atur sesuai kebutuhanmu',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelompokkan pilihan kos agar lebih mudah dijelajahi.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          for (var index = 0; index < categories.length; index++) ...[
            _CategoryCard(
              category: categories[index],
              itemCount: appState.items
                  .where((item) => item.categoryId == categories[index].id)
                  .length,
              index: index,
              onEdit: () => _showCategoryDialog(context, categories[index]),
              onDelete: () => _confirmDelete(
                context,
                categories[index],
                appState.items
                    .where((item) => item.categoryId == categories[index].id)
                    .length,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.itemCount,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final int itemCount;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accents = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
    ];
    final accent = accents[index % accents.length];
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 6, 15),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.home_work_outlined, color: accent),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount tempat tinggal',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit ${category.name}',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
          IconButton(
            tooltip: 'Hapus ${category.name}',
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
