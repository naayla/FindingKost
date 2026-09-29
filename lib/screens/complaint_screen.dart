import 'package:flutter/material.dart';

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
      _reports.insert(0, '$_category: ${_descriptionController.text.trim()}');
      _descriptionController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaduan dicatat selama sesi ini.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan pengaduan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Ada yang perlu\ndiperbaiki?',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700, height: 1.18),
          ),
          const SizedBox(height: 8),
          Text(
            'Ceritakan kendala atau masukanmu kepada kami.',
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
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Fasilitas kos',
                      child: Text('Fasilitas kos'),
                    ),
                    DropdownMenuItem(
                      value: 'Informasi kos',
                      child: Text('Informasi kos'),
                    ),
                    DropdownMenuItem(
                      value: 'Kendala aplikasi',
                      child: Text('Kendala aplikasi'),
                    ),
                    DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                  ],
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
                    labelText: 'Detail pengaduan',
                    hintText: 'Jelaskan apa yang terjadi...',
                  ),
                  validator: (value) => value == null || value.trim().length < 8
                      ? 'Isi minimal 8 karakter.'
                      : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    key: const Key('report-submit'),
                    onPressed: _submitReport,
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Kirim pengaduan'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Laporan sesi ini',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (_reports.isEmpty)
            Text(
              'Belum ada laporan.',
              style: TextStyle(color: colors.onSurfaceVariant),
            )
          else
            for (final report in _reports)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.check_circle_outline,
                  color: colors.primary,
                ),
                title: Text(
                  report,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
      ),
    );
  }
}
