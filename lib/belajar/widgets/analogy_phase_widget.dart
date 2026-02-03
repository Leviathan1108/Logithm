import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../widgets/custom_icon_widget.dart';

class AnalogyPhaseWidget extends StatelessWidget {
  final String title;
  final String analogyTitle;
  final String analogyDescription;
  final String realWorldExample;
  final String imageUrl;
  final String semanticLabel;

  const AnalogyPhaseWidget({
    super.key,
    required this.title,
    required this.analogyTitle,
    required this.analogyDescription,
    required this.realWorldExample,
    required this.imageUrl,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),

          // Illustration Image
          Container(
            width: double.infinity,
            height: 28.h, // Sedikit disesuaikan
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 28.h,
                fit: BoxFit.cover,
                semanticLabel: semanticLabel,
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Analogy Title Card
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    analogyTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Analogy Description
          Text(
            analogyDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 13.sp,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),

          // Real World Example Card
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'tips_and_updates',
                      color: theme.colorScheme.secondary,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Penerapan Nyata',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  realWorldExample,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Bagian Making Connection Dihapus
        ],
      ),
    );
  }
}