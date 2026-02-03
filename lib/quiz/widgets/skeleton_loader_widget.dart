import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Skeleton loader widget shown during data fetch
class SkeletonLoaderWidget extends StatefulWidget {
  const SkeletonLoaderWidget({super.key});

  @override
  State<SkeletonLoaderWidget> createState() => _SkeletonLoaderWidgetState();
}

class _SkeletonLoaderWidgetState extends State<SkeletonLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildShimmer(context, 48, 48, isCircle: true),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmer(context, double.infinity, 16),
                          SizedBox(height: 1.h),
                          _buildShimmer(context, 30.w, 12),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    _buildShimmer(context, 20.w, 24),
                    SizedBox(width: 2.w),
                    _buildShimmer(context, 20.w, 24),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildShimmer(context, double.infinity, 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context, double width, double height,
      {bool isCircle = false}) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}
