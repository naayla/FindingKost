import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class OwnerInboxScreen extends StatelessWidget {
  const OwnerInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;
    final messages = appState.ownerMessages;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesan Masuk & Chat Pemilik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: colors.outline),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada pesan dari pencari kos',
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
    );
  }
}
