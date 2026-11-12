import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/app_state.dart';

class OwnerInboxScreen extends StatelessWidget {
  const OwnerInboxScreen({super.key});

  void _showOwnerBookingDialog(BuildContext context, BookingModel booking) {
    final appState = context.read<AppState>();
    final isPending = booking.status == 'Menunggu Konfirmasi';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelola Pengajuan Sewa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking.kostTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 20),
            Text('• Nama Pemesan: ${booking.userName}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Email: ${booking.userEmail}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Gender: ${booking.seekerGender}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Status Nikah: ${booking.seekerMarriageStatus}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Kapasitas / Orang: ${booking.occupantsCount}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Durasi Sewa: ${booking.durationMonths}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text('• Rencana Masuk: ${booking.startDate}', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: booking.status == 'Disetujui'
                    ? Colors.green.withValues(alpha: 0.15)
                    : booking.status == 'Ditolak'
                        ? Colors.red.withValues(alpha: 0.15)
                        : Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: ${booking.status}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: booking.status == 'Disetujui'
                      ? Colors.green
                      : booking.status == 'Ditolak'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          if (isPending) ...[
            OutlinedButton(
              onPressed: () {
                appState.updateBookingStatus(booking.id, 'Ditolak');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengajuan sewa ditolak.')),
                );
              },
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Tolak'),
            ),
            FilledButton(
              onPressed: () {
                appState.updateBookingStatus(booking.id, 'Disetujui');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengajuan sewa disetujui!')),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2D6A4F)),
              child: const Text('Setujui'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final messages = appState.ownerMessages;
    final bookings = appState.bookings;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pesan & Pengajuan Masuk',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pesan Chat'),
              Tab(text: 'Pengajuan Sewa'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Pesan Chat Masuk
            messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: colors.outline),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada pesan chat dari pencari kos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pesan dari pencari kos akan muncul di sini secara real-time.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colors.primaryContainer,
                                    child: Text(
                                      msg.seekerName.isNotEmpty ? msg.seekerName[0].toUpperCase() : 'P',
                                      style: TextStyle(color: colors.onPrimaryContainer, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          msg.seekerName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.email_outlined, size: 12, color: colors.primary),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Email: ${msg.seekerEmail}',
                                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.primary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!msg.isRead)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Baru',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              const Divider(height: 20),
                              Text(
                                'Kos: ${msg.kostTitle}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.secondary),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  msg.message,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      appState.markMessageAsRead(msg.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Membalas pesan ke ${msg.seekerEmail}...')),
                                      );
                                    },
                                    icon: const Icon(Icons.reply_rounded, size: 16),
                                    label: const Text('Balas Pesan'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      minimumSize: const Size(0, 36),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            // Tab 2: Pengajuan Sewa (Booking) Masuk dari Pencari
            bookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border_rounded, size: 64, color: colors.outline),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada pengajuan sewa masuk',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pengajuan sewa dari pencari kos akan muncul di sini.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showOwnerBookingDialog(context, booking),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        booking.kostTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: booking.status == 'Disetujui'
                                            ? Colors.green.withValues(alpha: 0.15)
                                            : booking.status == 'Ditolak'
                                                ? Colors.red.withValues(alpha: 0.15)
                                                : Colors.orange.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        booking.status,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: booking.status == 'Disetujui'
                                              ? Colors.green
                                              : booking.status == 'Ditolak'
                                                  ? Colors.red
                                                  : Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text('Pencari: ${booking.userName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text('Email: ${booking.userEmail}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('• Gender: ${booking.seekerGender}', style: const TextStyle(fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('• Status Nikah: ${booking.seekerMarriageStatus}', style: const TextStyle(fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('• Kapasitas/Orang: ${booking.occupantsCount}', style: const TextStyle(fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text('• Durasi: ${booking.durationMonths} (Masuk: ${booking.startDate})', style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Ketuk untuk kelola / konfirmasi',
                                      style: TextStyle(fontSize: 11, color: colors.primary, fontStyle: FontStyle.italic),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: colors.primary),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
