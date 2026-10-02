import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  late final List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      const _ChatMessage(
        text: 'Hai! Saya asisten cerdas Finding Kost. Ada yang bisa saya bantu hari ini?',
        isUser: false,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedMessage]) {
    final text = (suggestedMessage ?? _controller.text).trim();
    if (text.isEmpty) return;

    final appState = context.read<AppState>();
    final isOwner = appState.isOwner;
    final query = text.toLowerCase();

    String reply;
    if (isOwner) {
      if (query.contains('tambah') || query.contains('katalog') || query.contains('pasang')) {
        reply = 'Untuk menambah katalog kos, gunakan tab "Tambah Kos" atau tombol "+" di halaman utama. Anda bisa memasukkan nama, lokasi Google Maps, harga, dan fasilitas.';
      } else if (query.contains('edit') || query.contains('status') || query.contains('penuh')) {
        reply = 'Anda dapat mengubah status ketersediaan (Tersedia/Penuh) secara cepat di kartu kos pada halaman utama atau dari tombol aksi di halaman detail.';
      } else if (query.contains('kategori')) {
        reply = 'Atur kelompok kos Anda melalui menu "Kategori". Anda dapat menambah atau mengedit nama kategori sesuai kebutuhan.';
      } else {
        reply = 'Sebagai Pemilik Kost, Anda bisa mengelola katalog, menambah kos baru, mengubah status ketersediaan, serta melihat lokasi kos Anda di Peta Google Maps.';
      }
    } else {
      if (query.contains('harga') || query.contains('budget') || query.contains('murah')) {
        reply = 'Di Finding Kost, kos tersedia mulai dari Rp 600.000 per bulan. Anda bisa memfilter atau mencari berdasarkan budget Anda di halaman utama.';
      } else if (query.contains('peta') || query.contains('lokasi') || query.contains('map')) {
        reply = 'Buka tab "Peta Kos" untuk melihat titik lokasi kos secara langsung terintegrasi Google Maps di seluruh wilayah Medan.';
      } else if (query.contains('wa') || query.contains('hubungi') || query.contains('pesan')) {
        reply = 'Buka halaman detail kos pilihan Anda, lalu tekan tombol "Hubungi Pemilik (WhatsApp)" untuk langsung berkomunikasi dengan pengelola kos.';
      } else if (query.contains('simpan') || query.contains('favorit')) {
        reply = 'Tekan ikon bookmark pada kartu atau halaman detail kos untuk menyimpannya ke daftar "Tersimpan".';
      } else {
        reply = 'Saya dapat membantu Anda mencari kos berdasarkan lokasi di Medan, kisaran harga, petunjuk penggunaan Peta Google Maps, dan cara menghubungi pemilik kos.';
      }
    }

    setState(() {
      _messages
        ..add(_ChatMessage(text: text, isUser: true))
        ..add(_ChatMessage(text: reply, isUser: false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isOwner = context.watch<AppState>().isOwner;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwner ? 'Asisten Pemilik Kost' : 'Asisten Finding Kost'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? colors.primary
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_messages.length == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: isOwner
                    ? [
                        ActionChip(
                          label: const Text('Cara tambah kos baru'),
                          onPressed: () => _sendMessage('Cara tambah kos baru'),
                        ),
                        ActionChip(
                          label: const Text('Cara ubah status penuh/tersedia'),
                          onPressed: () => _sendMessage('Cara ubah status penuh'),
                        ),
                      ]
                    : [
                        ActionChip(
                          label: const Text('Kos di bawah 1 juta'),
                          onPressed: () => _sendMessage('Cari kos di bawah 1 juta'),
                        ),
                        ActionChip(
                          label: const Text('Cara buka di Google Maps'),
                          onPressed: () => _sendMessage('Cara buka di Google Maps'),
                        ),
                        ActionChip(
                          label: const Text('Cara hubungi pemilik WA'),
                          onPressed: () => _sendMessage('Cara hubungi pemilik WA'),
                        ),
                      ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('chat-input'),
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Tulis pertanyaan...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const Key('chat-send'),
                  tooltip: 'Kirim pesan',
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
