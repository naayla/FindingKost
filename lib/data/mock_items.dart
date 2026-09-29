import '../models/main_item.dart';

List<MainItem> initialItems = List.generate(
  20,
      (index) => MainItem(
    id: 'item_${index + 1}',
    categoryId: 'cat_${(index % 5) + 1}', // Menyebarkan relasi ke 5 kategori
    title: 'Item Utama ${index + 1}',
    description: 'Deskripsi lengkap untuk item utama nomor ${index + 1}.',
    price: (index + 1) * 15000.0,
    rating: 4.0 + (index % 10) * 0.1,
  ),
);