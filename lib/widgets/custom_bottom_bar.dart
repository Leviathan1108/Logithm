import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showMapBadge;
  final bool showQuizBadge;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showMapBadge = false,
    this.showQuizBadge = false,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _lastTappedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index != widget.currentIndex) {
      HapticFeedback.lightImpact();
      setState(() {
        _lastTappedIndex = index;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 0. HOME
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
                showBadge: false,
              ),
              // 1. MAP
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.map_rounded,
                label: 'Map',
                showBadge: widget.showMapBadge,
              ),
              // 2. LEADERBOARD (BARU)
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.leaderboard_rounded,
                label: 'Rank',
                showBadge: false,
              ),
              // 3. QUIZ
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.quiz_rounded,
                label: 'Quiz',
                showBadge: widget.showQuizBadge,
              ),
              // 4. PROFILE
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.person_rounded,
                label: 'Profile',
                showBadge: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool showBadge,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.currentIndex == index;
    final isAnimating = _lastTappedIndex == index;

    // Logika Warna berdasarkan Index
    Color selectedColor;
    if (index == 1) {
      selectedColor = colorScheme.primary; // Teal for Map
    } else if (index == 2) {
      selectedColor = Colors.orange; // Orange for Leaderboard
    } else if (index == 3) {
      selectedColor = colorScheme.secondary; // Purple for Quiz
    } else {
      selectedColor = colorScheme.primary; // Default
    }

    final color = isSelected ? selectedColor : colorScheme.onSurfaceVariant;

    Widget navItemContent = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 26, // Sedikit diperkecil agar muat 5 item
              color: color,
            ),
            if (showBadge)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surface,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 10, // Font sedikit diperkecil
          ),
        ),
      ],
    );

    if (isAnimating) {
      navItemContent = ScaleTransition(
        scale: _scaleAnimation,
        child: navItemContent,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(index),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: navItemContent,
        ),
      ),
    );
  }
}