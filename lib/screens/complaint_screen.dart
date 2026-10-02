import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _reports = <String>[];
  String _category = 'Fasilitas kos';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _reports.insert(0, '[$_category] ${_descriptionController.text.trim()}');
      _descriptionController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaduan berhasil terkirim dan dicatat.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isOwner = context.watch<AppState>().isOwner;

    final categoriesList = isOwner
        ? const [
            DropdownMenuItem(
              value: 'Keluhan Aplikasi',
              child: Text('Keluhan Aplikasi'),
            ),
            DropdownMenuItem(
              value: 'Bantuan Peta Location',
              child: Text('Bantuan Peta Location'),
            ),
            DropdownMenuItem(
              value: 'Informasi Akun Pemilik',
              child: Text('Informasi Akun Pemilik'),
            ),
            DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
          ]
        : const [
            DropdownMenuItem(
              value: 'Fasilitas kos',
              child: Text('Fasilitas kos'),
            ),
            DropdownMenuItem(
              value: 'Informasi kos tidak sesuai',
              child: Text('Informasi kos tidak sesuai'),
            ),
            DropdownMenuItem(
              value: 'Pemilik tidak merespon',
              child: Text('Pemilik tidak merespon'),
            ),
            DropdownMenuItem(
              value: 'Kendala aplikasi',
              child: Text('Kendala aplikasi'),
            ),
            DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
          ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Pengaduan & Layanan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            isOwner ? 'Ada Kendala\nPengelolaan?' : 'Ada Kendala Atau\nPengaduan Kos?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.18,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isOwner
                ? 'Sampaikan keluhan teknis atau bantuan pendaftaran properti kos kepada tim bantuan Finding Kost.'
                : 'Ceritakan kendala atau informasi kos yang tidak akurat kepada tim bantuan kami.',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori Laporan',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categoriesList,
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const Key('report-description'),
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Detail Pengaduan',
                    hintText: 'Jelaskan secara detail apa yang terjadi...',
                  ),
                  validator: (value) => value == null || value.trim().length < 8
                      ? 'Isi pengaduan minimal 8 karakter.'
                      : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    key: const Key('report-submit'),
                    onPressed: _submitReport,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Kirim Laporan Pengaduan'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Riwayat Pengaduan Sesi Ini',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          if (_reports.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Belum ada laporan pengaduan yang dikirim.',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            )
          else
            for (final report in _reports)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: colors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          report,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
