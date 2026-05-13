import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class MedicineImagePreviewCard extends StatelessWidget {
  final String imageUrl;

  const MedicineImagePreviewCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(IconsaxPlusLinear.gallery_slash, size: 64, color: Colors.white54),
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 40,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(IconsaxPlusLinear.close_circle, color: Colors.white, size: 36),
          ),
        ),
      ],
    );
  }
}
