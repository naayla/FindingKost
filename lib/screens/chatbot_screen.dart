import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      text: 'Hai! Aku bisa bantu cari kos berdasarkan harga, lokasi, atau kebutuhanmu.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedMessage]) {
    final text = (suggestedMessage ?? _controller.text).trim();
    if (text.isEmpty) return;

    final query = text.toLowerCase();
    final reply = query.contains('harga') || query.contains('budget')
        ? 'Pilihan kos tersedia mulai dari Rp700.000 per bulan. Kamu juga bisa mencari kos berdasarkan harga di halaman utama.'
        : query.contains('lokasi') ||
              query.contains('dekat') ||
              query.contains('medan')
        ? 'Ada pilihan kos di Medan Baru, Medan Selayang, dan Medan Kota. Gunakan kolom pencarian untuk memilih area.'
        : query.contains('lapor') || query.contains('pengaduan')
        ? 'Kirim kendala atau masukan lewat tombol pengaduan di halaman utama.'
        : 'Aku bisa bantu soal harga kos, area di Medan, atau cara mengirim pengaduan.';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Asisten Finding Kost')),
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
                children: [
                  ActionChip(
                    label: const Text('Kos di bawah 1 juta'),
                    onPressed: () => _sendMessage('Cari kos di bawah 1 juta'),
                  ),
                  ActionChip(
                    label: const Text('Area terdekat'),
                    onPressed: () => _sendMessage('Area terdekat'),
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
                      hintText: 'Tulis pesan...',
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
