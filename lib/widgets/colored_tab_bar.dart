import 'package:flutter/material.dart';

/// A widget that displays a horizontal row of [Tab]s with a specified [Color].
class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a tab bar that paints its area with the specified [Color].
  const ColoredTabBar({
    super.key,
    required this.color,
    required this.child,
  });

  /// The color to paint the background area with.
  final Color color;
  final TabBar child;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: child,
    );
  }
}
