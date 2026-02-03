import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Ganti import ini ke lokasi widget yang sebenarnya
import '../../../../widgets/custom_image_widget.dart';
import '../../../../widgets/custom_icon_widget.dart';

// Jika lokasi widget anda di lib/widgets/, pastikan path relative-nya benar.
// Struktur asumsi:
// lib/
//   quiz/
//     widgets/
//       empty_state_widget.dart
//   widgets/
//     custom_image_widget.dart

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pastikan CustomImageWidget sudah dibuat di lib/widgets/
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1516534775068-ba3e7458af70?w=400',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
              semanticLabel:
                  'Illustration of a person studying with books and laptop',
            ),
            SizedBox(height: 3.h),
            Text(
              'No Quizzes Available Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Complete more lessons to unlock exciting programming challenges!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/material-map-screen');
              },
              // Pastikan CustomIconWidget sudah dibuat di lib/widgets/
              icon: CustomIconWidget(
                iconName: 'school',
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
              label: const Text('Complete More Lessons'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}