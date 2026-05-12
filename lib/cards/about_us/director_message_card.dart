import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class DirectorMessageCard extends StatelessWidget {
  final AboutUs? aboutUs;
  final VoidCallback onEdit;

  const DirectorMessageCard({super.key, this.aboutUs, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(51),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Director Photo
              Container(
                width: 160,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(24),
                  image: aboutUs?.directorPhoto != null
                      ? DecorationImage(
                          image: NetworkImage(
                            aboutUs!.directorPhoto!.startsWith('http')
                                ? aboutUs!.directorPhoto!
                                : '${ApiUrls.baseUrl}${aboutUs!.directorPhoto!.startsWith('/') ? aboutUs!.directorPhoto!.substring(1) : aboutUs!.directorPhoto}',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: aboutUs?.directorPhoto == null
                    ? const Icon(IconsaxPlusLinear.user, size: 64, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 40),
              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(IconsaxPlusLinear.quote_down, color: Colors.white, size: 40),
                    const SizedBox(height: 20),
                    Text(
                      aboutUs?.directorMessage ?? 'No director message provided. Add an inspiring message to connect with your users and partners.',
                      style: AppTextStyles.header.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      aboutUs?.directorName ?? 'Director Name',
                      style: AppTextStyles.header.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'MANAGING DIRECTOR',
                      style: AppTextStyles.tagline.copyWith(
                        color: Colors.white.withAlpha(180),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(IconsaxPlusLinear.edit, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(51),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
