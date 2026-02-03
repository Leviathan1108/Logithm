import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../theme/app_theme.dart';

/// Definition phase widget for material learning
/// Provides technical explanation with code snippets
class DefinitionPhaseWidget extends StatefulWidget {
  final String title;
  final String technicalDefinition;
  final String codeExample;
  final String syntax;

  const DefinitionPhaseWidget({
    super.key,
    required this.title,
    required this.technicalDefinition,
    required this.codeExample,
    required this.syntax,
  });

  @override
  State<DefinitionPhaseWidget> createState() => _DefinitionPhaseWidgetState();
}

class _DefinitionPhaseWidgetState extends State<DefinitionPhaseWidget> {
  double _codeZoomScale = 1.0;

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
            widget.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),

          // Technical definition
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'description',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Definition',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  widget.technicalDefinition,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Syntax section
          Text(
            'Syntax',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.5.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Text(
              widget.syntax,
              style: AppTheme.getCodeTextStyle(
                isLight: theme.brightness == Brightness.light,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Code example with pinch-to-zoom
          Text(
            'Code Example',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.5.h),
          GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                _codeZoomScale =
                    (_codeZoomScale * details.scale).clamp(0.8, 2.0);
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Transform.scale(
                  scale: _codeZoomScale,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.codeExample,
                    style: AppTheme.getCodeTextStyle(
                      isLight: false,
                      fontSize: 13,
                    ).copyWith(
                      color: const Color(0xFFD4D4D4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                'Pinch to zoom code',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
