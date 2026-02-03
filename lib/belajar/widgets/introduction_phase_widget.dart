import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_icon_widget.dart';

class IntroductionPhaseWidget extends StatelessWidget {
  final String title;
  final String description;
  final String conceptOverview;

  const IntroductionPhaseWidget({
    super.key,
    required this.title,
    required this.description,
    required this.conceptOverview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),

          // Description (Lebih Panjang & Jelas)
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 14.sp, // Sedikit lebih besar
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),

          // Concept Overview Card (Inti Materi)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'lightbulb',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Konsep Inti',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  conceptOverview,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // Space kosong dihapus (Learning Objectives dibuang)
        ],
      ),
    );
  }
}