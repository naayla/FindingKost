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
    - Membutuhkan peta lokasi interaktif (OpenStreetMap `flutter_map`) untuk melihat sebaran kos di Medan secara gratis tanpa API Key.
* **Kendala Pengalaman (Pain Points)**:
    - Sering mengalami ketidaksesuaian data antara informasi promo dan ketersediaan kamar di lapangan.
    - Kesulitan membandingkan rentang harga kos secara langsung.

---

## 2. Peta Layar (Sitemap Layar Fungsional Terbaru)

1. **`LoginScreen`**: Layar autentikasi masuk pengguna dengan pemilih peran yang seimbang & sejajar (*Pencari Kost* vs *Pemilik Kost*).
2. **`RegisterScreen`**: Layar pendaftaran akun pengguna baru dengan penyimpanan data terintegrasi.
3. **`HomeScreen`**: Katalog utama rekomendasi kos, pencarian *dynamic*, filter kategori, tombol interaktif ke **Peta Sebaran (`MapScreen`)**, dan tombol **Filter & Urutkan** (*Bottom Sheet*).
4. **`DetailScreen`**: Tampilan rincian informasi unit kos dilengkapi fitur **Bagikan Kos (Share)**, **Kalkulator Estimasi Biaya**, **Pengajuan Sewa (Booking)**, serta **Ulasan & Rating Bintang Interaktif**.
5. **`ActivityScreen`**: Pusat riwayat pengajuan sewa (*booking*) dan log aktivitas akun secara *real-time*.
6. **`FormItemScreen`**: Formulir input untuk menambah dan mengubah data kos (CRUD Modul 1).
7. **`CategoryScreen`**: Layar pengelolaan referensi kategori kos (CRUD Modul 2).
8. **`ProfileScreen`**: Informasi profil akun dinamis berdasarkan data registrasi awal, statistik tersimpan, dan menu riwayat aktivitas.
9. **`MainNavigationScreen`**: Layar pembungkus (*wrapper*) berbasis `NavigationBar` untuk navigasi lintas halaman sesuai role.

---

## 3. Model Data & Fitur Unggulan Terbaru

* **Peta Interaktif (OpenStreetMap)**: Memuat titik-titik lokasi kos di Medan menggunakan `flutter_map` tanpa memerlukan Google Cloud API Key atau kartu kredit.
* **Pengajuan Sewa & Booking**: Sistem interaktif bagi pencari kos untuk mengajukan durasi sewa dan rencana masuk.
* **Kalkulator Biaya & Ulasan Interaktif**: Penghitungan otomatis total biaya sewa dan sistem rating bintang (1-5) interaktif.
* **Manajemen Peran & Profil Dinamis**: Penyelarasan data profil langsung dari data registrasi awal pengguna.
