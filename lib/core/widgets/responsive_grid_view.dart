/// Responsive GridView - automatically adjusts columns based on screen size.
///
/// Features:
/// - Automatic column count based on screen width
/// - Adaptive spacing
/// - Supports both fixed and scrollable layouts
/// - Responsive to orientation changes
library;

import 'package:flutter/material.dart';

import 'package:mcs/core/extensions/context_extensions.dart';

class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView({
    required this.children,
    super.key,
    this.padding,
    this.scrollable = true,
    this.childAspectRatio = 1.0,
    this.columnCount,
    this.itemSpacing,
  });

  /// Items to display in the grid.
  final List<Widget> children;

  /// Padding around the grid.
  final EdgeInsets? padding;

  /// Whether the grid should be scrollable.
  final bool scrollable;

  /// Aspect ratio of grid items.
  final double childAspectRatio;

  /// Custom column count (overrides automatic calculation).
  final int? columnCount;

  /// Custom spacing between items.
  final double? itemSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate column count
        final columns = columnCount ?? context.gridColumnsCount;

        // Calculate spacing
        final spacing = itemSpacing ?? context.adaptiveGridSpacing;

        // Calculate padding
        final gridPadding =
            padding ?? EdgeInsets.all(context.adaptivePaddingHorizontal);

        // Build the grid
        final grid = GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: !scrollable,
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: gridPadding,
          children: children,
        );

        return scrollable ? grid : SingleChildScrollView(child: grid);
      },
    );
  }
}

/// Alternative: Responsive GridView using GridView.builder for lazy loading.
class ResponsiveGridViewBuilder extends StatelessWidget {
  const ResponsiveGridViewBuilder({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.padding,
    this.scrollable = true,
    this.childAspectRatio = 1.0,
    this.columnCount,
    this.itemSpacing,
  });

  /// Number of items in the grid.
  final int itemCount;

  /// Builder function for grid items.
  final IndexedWidgetBuilder itemBuilder;

  /// Padding around the grid.
  final EdgeInsets? padding;

  /// Whether the grid should be scrollable.
  final bool scrollable;

  /// Aspect ratio of grid items.
  final double childAspectRatio;

  /// Custom column count (overrides automatic calculation).
  final int? columnCount;

  /// Custom spacing between items.
  final double? itemSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate column count
        final columns = columnCount ?? context.gridColumnsCount;

        // Calculate spacing
        final spacing = itemSpacing ?? context.adaptiveGridSpacing;

        // Calculate padding
        final gridPadding =
            padding ?? EdgeInsets.all(context.adaptivePaddingHorizontal);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          shrinkWrap: !scrollable,
          physics: scrollable
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          padding: gridPadding,
        );
      },
    );
  }
}

/// Responsive GridView with section headers.
class ResponsiveGridSection extends StatelessWidget {
  const ResponsiveGridSection({
    required this.children,
    super.key,
    this.title,
    this.padding,
    this.childAspectRatio = 1.0,
    this.columnCount,
  });

  /// Section title.
  final String? title;

  /// Items to display in the grid.
  final List<Widget> children;

  /// Padding around the section.
  final EdgeInsets? padding;

  /// Aspect ratio of grid items.
  final double childAspectRatio;

  /// Custom column count (overrides automatic calculation).
  final int? columnCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: context.adaptivePaddingHorizontal,
                  vertical: context.adaptivePaddingVertical,
                ),
            child: Text(
              title!,
              style: context.textThemeSafe.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: context.adaptivePaddingVertical),
        ],
        ResponsiveGridView(
          padding: padding,
          scrollable: false,
          childAspectRatio: childAspectRatio,
          columnCount: columnCount,
          children: children,
        ),
      ],
    );
  }
}
