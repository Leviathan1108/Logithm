import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for educational mobile app
/// Implements clean, minimal design with contextual actions
/// Supports learning and challenge modes with appropriate styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title
  final String title;

  /// Whether to show back button
  final bool showBackButton;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Whether this is a challenge mode screen (uses purple accent)
  final bool isChallengeMode;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.isChallengeMode = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Determine accent color based on mode
    final accentColor = isChallengeMode
        ? colorScheme.secondary // Purple for challenge mode
        : colorScheme.primary; // Teal for learning mode

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: elevation,
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.1),
      leading: leading ??
          (showBackButton ? _buildBackButton(context, accentColor) : null),
      actions: actions,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  Widget _buildBackButton(BuildContext context, Color accentColor) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: accentColor,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      tooltip: 'Back',
      splashRadius: 24,
    );
  }
}

/// Custom app bar with progress indicator for learning screens
class CustomAppBarWithProgress extends StatelessWidget
    implements PreferredSizeWidget {
  /// App bar title
  final String title;

  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Whether to show back button
  final bool showBackButton;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Whether this is a challenge mode screen
  final bool isChallengeMode;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  const CustomAppBarWithProgress({
    super.key,
    required this.title,
    required this.progress,
    this.showBackButton = true,
    this.actions,
    this.isChallengeMode = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final accentColor =
        isChallengeMode ? colorScheme.secondary : colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: accentColor,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        if (onBackPressed != null) {
                          onBackPressed!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      tooltip: 'Back',
                      splashRadius: 24,
                    ),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (actions != null)
                    ...actions!
                  else
                    const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            // Progress indicator
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom app bar action button with consistent styling
class CustomAppBarAction extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Tooltip text
  final String? tooltip;

  /// Whether to show a badge
  final bool showBadge;

  /// Badge count (if > 0, shows number instead of dot)
  final int badgeCount;

  const CustomAppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          tooltip: tooltip,
          splashRadius: 24,
          color: colorScheme.onSurface,
        ),
        if (showBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: badgeCount > 0
                  ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
                  : null,
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                shape: badgeCount > 0 ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: badgeCount > 0 ? BorderRadius.circular(8) : null,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 1.5,
                ),
              ),
              child: badgeCount > 0
                  ? Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
