import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/app_state.dart';
import '../widgets/kost_image.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  void _showBookingDetailDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pengajuan Sewa'),
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
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final bookings = appState.bookings;
    final activityLogs = appState.activityLogs;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Aktivitas & Booking',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pengajuan Sewa'),
              Tab(text: 'Riwayat Aktivitas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            bookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border_rounded,
                            size: 64, color: colors.outline),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada pengajuan sewa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ajukan sewa kamar dari halaman detail kos.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
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
                          onTap: () => _showBookingDetailDialog(context, booking),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                KostImage(
                                  imageUrl: booking.kostImageUrl,
                                  width: 70,
                                  height: 70,
                                  borderRadius: 12,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.kostTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Durasi: ${booking.durationMonths} • Mulai: ${booking.startDate}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.primaryContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          booking.status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: colors.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activityLogs.length,
              itemBuilder: (context, index) {
                final log = activityLogs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: colors.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.history_rounded, color: colors.primary),
                    title: Text(
                      log,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Baru saja',
                      style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
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
