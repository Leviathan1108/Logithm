import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Individual quiz card widget displaying quiz information and status
class QuizCardWidget extends StatelessWidget {
  final Map<String, dynamic> quiz;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const QuizCardWidget({
    super.key,
    required this.quiz,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = quiz['isUnlocked'] as bool;
    final isCompleted = quiz['isCompleted'] as bool;
    final score = quiz['score'] as int?;
    final difficulty = quiz['difficulty'] as String;
    final estimatedTime = quiz['estimatedTime'] as String;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: isUnlocked
            ? () {
                HapticFeedback.lightImpact();
                onTap();
              }
            : null,
        onLongPress: isUnlocked
            ? () {
                HapticFeedback.mediumImpact();
                onLongPress?.call();
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                      theme.colorScheme.secondary.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            color:
                isUnlocked ? null : theme.colorScheme.surfaceContainerHighest,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildThemeIcon(context),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isUnlocked
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          quiz['theme'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted && score != null)
                    _buildScoreBadge(context, score),
                  if (!isUnlocked) _buildLockIcon(context),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    CustomIconWidget(
                      iconName: 'signal_cellular_alt',
                      size: 16,
                      color: _getDifficultyColor(context, difficulty),
                    ),
                    difficulty,
                    _getDifficultyColor(context, difficulty),
                  ),
                  SizedBox(width: 2.w),
                  _buildInfoChip(
                    context,
                    CustomIconWidget(
                      iconName: 'schedule',
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    estimatedTime,
                    theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              isUnlocked
                  ? _buildActionButton(context, isCompleted)
                  : _buildLearnFirstButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeIcon(BuildContext context) {
    final theme = Theme.of(context);
    final themeIconMap = {
      'Robot Rescue': 'smart_toy',
      'Bank Vault': 'account_balance',
      'Maze': 'grid_on',
      'Data Sort': 'sort',
      'Logic Gates': 'memory',
    };

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(
        iconName: themeIconMap[quiz['theme']] ?? 'quiz',
        size: 32,
        color: theme.colorScheme.secondary,
      ),
    );
  }

  Widget _buildScoreBadge(BuildContext context, int score) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'star',
            size: 16,
            color: theme.colorScheme.onTertiary,
          ),
          SizedBox(width: 1.w),
          Text(
            score.toString(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockIcon(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: CustomIconWidget(
        iconName: 'lock',
        size: 20,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, Widget icon, String label, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isCompleted) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isCompleted ? 'refresh' : 'play_arrow',
              size: 20,
              color: theme.colorScheme.onSecondary,
            ),
            SizedBox(width: 2.w),
            Text(
              isCompleted ? 'Retry for Better Score' : 'Start Quiz',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnFirstButton(BuildContext context) {
    final theme = Theme.of(context);
    final prerequisite = quiz['prerequisite'] as String;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/material-map-screen');
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.outline),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'school',
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Learn First',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Complete: $prerequisite',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    final theme = Theme.of(context);
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return theme.colorScheme.primary;
      case 'medium':
        return theme.colorScheme.tertiary;
      case 'hard':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
