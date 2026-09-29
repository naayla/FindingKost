# Dokumen Ringkas Proyek Finding Kost

---

## 1. Persona Utama

* **Nama Persona**: Budi Santoso
* **Usia**: 19 Tahun
* **Pekerjaan/Status**: Mahasiswa Undergraduate Universitas Sumatera Utara (USU)
* **Latar Belakang**: Mahasiswa baru dari luar kota yang membutuhkan tempat tinggal di dekat lokasi kampus Fasilkom-TI.
* **Tujuan & Kebutuhan (Goals & Needs)**:
    - Mencari hunian kamar kos yang nyaman, aman, dan dekat dengan kampus.
    - Membutuhkan kejelasan estimasi harga, fasilitas kamar, dan tipe kos (Putri, Putra, Campur, Eksklusif, Bebas 24 Jam).
    - Membutuhkan peta lokasi interaktif (Google My Maps) untuk mengukur jarak kos ke fasilitas umum.
* **Kendal Pengalaman (Pain Points)**:
    - Sering mengalami ketidaksesuaian data antara informasi promo dan ketersediaan kamar di lapangan.
    - Kesulitan membandingkan rentang harga kos secara langsung.

---

## 2. Peta Layar (Sitemap 8 Layar Fungsional)

1. **`LoginScreen`**: Layar autentikasi masuk pengguna menggunakan email dan kata sandi beserta validasi input.
2. **`RegisterScreen`**: Layar pendaftaran akun pengguna baru.
3. **`HomeScreen`**: Katalog utama rekomendasi kos, pencarian *dynamic*, penyaringan (filter), dan integrasi dialog Google My Maps.
4. **`DetailScreen`**: Tampilan rincian informasi satu unit kos (foto, harga, lokasi, rating, deskripsi, serta aksi Edit/Hapus).
5. **`FormItemScreen`**: Formulir input untuk menambah dan mengubah data kos (CRUD Modul 1).
6. **`CategoryScreen`**: Layar pengelolaan referensi kategori kos (CRUD Modul 2).
7. **`ProfileScreen`**: Informasi profil akun pengguna dan pengaturan preferensi aplikasi.
8. **`MainNavigationScreen`**: Layar pembungkus (*wrapper*) berbasis `BottomNavigationBar` untuk navigasi terintegrasi lintas halaman.

---

## 3. Model Data & Relasi ID

Aplikasi mengelola 2 entitas basis data utama yang terhubung melalui `categoryId`:

### A. Model `Category` (Data Referensi)
* `id` (String - Primary Key)
* `name` (String)
* `iconName` (String)

### B. Model `Kost` (Data Utama)
* `id` (String - Primary Key)
* `categoryId` (String - Foreign Key mengacu ke `Category.id`)
* `title` (String)
* `location` (String)
* `price` (String)
* `rating` (double)
* `imageUrl` (String)