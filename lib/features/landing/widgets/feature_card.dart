/// Feature card widget - displays a single feature.
///
/// Responsive design that handles different screen sizes gracefully.
/// Uses Flexible to prevent RenderFlex overflow on smaller screens.
/// Tappable to navigate to feature detail screen.
library;

import 'package:flutter/material.dart';
import 'package:mcs/core/theme/text_styles.dart';
import 'package:mcs/core/utils/extensions.dart';
import 'package:mcs/features/landing/screens/feature_detail_screen.dart';

class FeatureCard extends StatefulWidget {
  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSmall = context.isSmall;
    final padding = isSmall ? 16.0 : 24.0;
    final iconSize = isSmall ? 28.0 : 32.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.translate(
        offset: Offset(0, _isHovered ? -8 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => FeatureDetailScreen(
                    title: widget.title,
                    description: widget.description,
                    icon: widget.icon,
                    color: widget.color,
                  ),
                ),
              );
            },
            child: Card(
              elevation: _isHovered ? 8 : 2,
              child: Padding(
                padding: EdgeInsets.all(padding),
                // ✅ Use Flexible to prevent overflow on small screens
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ✅ Main axis size: min to prevent overflow
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Container
                    Container(
                      padding: EdgeInsets.all(
                        iconSize * 0.375,
                      ), // Responsive padding
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: iconSize,
                      ),
                    ),
                    SizedBox(height: isSmall ? 12 : 16),

                    // Title - Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmall ? 14 : 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: isSmall ? 6 : 8),

                    // Description - Flexible with expanded to fill available space
                    Flexible(
                      child: Text(
                        widget.description,
                        style: TextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                          fontSize: isSmall ? 12 : 13,
                        ),
                        maxLines: isSmall ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
