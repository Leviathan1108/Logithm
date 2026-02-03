import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Filter chips widget for sorting and filtering quizzes
class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = [
      {'label': 'All', 'icon': 'apps'},
      {'label': 'Easy', 'icon': 'signal_cellular_alt'},
      {'label': 'Medium', 'icon': 'signal_cellular_alt'},
      {'label': 'Hard', 'icon': 'signal_cellular_alt'},
      {'label': 'Completed', 'icon': 'check_circle'},
      {'label': 'Unlocked', 'icon': 'lock_open'},
    ];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['label'];
          return _buildFilterChip(
            context,
            filter['label']!,
            filter['icon']!,
            isSelected,
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, String iconName, bool isSelected) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 16,
            color: isSelected
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 1.w),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        HapticFeedback.selectionClick();
        onFilterChanged(label);
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.secondary,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.secondary
              : theme.colorScheme.outline,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
    );
  }
}
