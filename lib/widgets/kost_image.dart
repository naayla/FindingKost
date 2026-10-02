import 'package:flutter/material.dart';

class KostImage extends StatelessWidget {
  const KostImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width,
    this.borderRadius = 18,
  });

  final String imageUrl;
  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final uri = Uri.tryParse(imageUrl);
    final optimizedImageUrl =
        uri != null && uri.host.toLowerCase() == 'images.unsplash.com'
        ? uri
              .replace(
                queryParameters: {
                  ...uri.queryParameters,
                  'auto': 'format',
                  'fit': 'crop',
                  'w': '1400',
                  'q': '88',
                },
              )
              .toString()
        : imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        optimizedImageUrl,
        width: width ?? double.infinity,
        height: height,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width ?? double.infinity,
            height: height,
            color: colors.surfaceContainerHighest,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress.expectedTotalBytes == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: width ?? double.infinity,
          height: height,
          color: colors.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(
            Icons.home_work_outlined,
            size: 42,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
