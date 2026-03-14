/// ═══════════════════════════════════════════════════════════════════════════
/// RESPONSIVE GRID | شبكات متجاوبة
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Grid and layout widgets with adaptive column counts based on screen size

library;

import 'package:flutter/material.dart';

import 'package:mcs/core/ui/responsive_container.dart';
import 'package:mcs/core/ui/spacing.dart';

/// Responsive grid with adaptive column count
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.spacing = AppSpacing.lg,
    this.runSpacing = AppSpacing.lg,
    this.childAspectRatio = 1.0,
    this.smallColumns = 1,
    this.mediumColumns = 2,
    this.largeColumns = 3,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final int smallColumns;
  final int mediumColumns;
  final int largeColumns;

  @override
  Widget build(BuildContext context) {
    final columns = context.isSmallScreen
        ? smallColumns
        : context.isMediumScreen
            ? mediumColumns
            : largeColumns;

    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// Responsive grid builder with adaptive column count
class ResponsiveGridBuilder extends StatelessWidget {
  const ResponsiveGridBuilder({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.spacing = AppSpacing.lg,
    this.runSpacing = AppSpacing.lg,
    this.childAspectRatio = 1.0,
    this.smallColumns = 1,
    this.mediumColumns = 2,
    this.largeColumns = 3,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final int smallColumns;
  final int mediumColumns;
  final int largeColumns;

  @override
  Widget build(BuildContext context) {
    final columns = context.isSmallScreen
        ? smallColumns
        : context.isMediumScreen
            ? mediumColumns
            : largeColumns;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
      ),
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: itemBuilder,
    );
  }
}

/// Responsive wrapped grid for dynamic column layout
class ResponsiveWrapGrid extends StatelessWidget {
  const ResponsiveWrapGrid({
    required this.children,
    super.key,
    this.spacing = AppSpacing.lg,
    this.runSpacing = AppSpacing.lg,
    this.childAspectRatio = 1.0,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final childWidth = context.isSmallScreen
        ? context.screenWidth - (2 * AppSpacing.lg)
        : context.isMediumScreen
            ? (context.screenWidth - (2 * AppSpacing.lg) - spacing) / 2
            : (context.screenWidth - (2 * AppSpacing.lg) - (spacing * 2)) / 3;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        return SizedBox(
          width: childWidth,
          height: childWidth / childAspectRatio,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Responsive masonry grid with staggered layout
class ResponsiveMasonryGrid extends StatelessWidget {
  const ResponsiveMasonryGrid({
    required this.children,
    super.key,
    this.spacing = AppSpacing.lg,
    this.smallColumns = 1,
    this.mediumColumns = 2,
    this.largeColumns = 3,
  });

  final List<Widget> children;
  final double spacing;
  final int smallColumns;
  final int mediumColumns;
  final int largeColumns;

  @override
  Widget build(BuildContext context) {
    final columns = context.isSmallScreen
        ? smallColumns
        : context.isMediumScreen
            ? mediumColumns
            : largeColumns;

    return CustomMultiChildLayout(
      delegate: _MasonryDelegate(
        columns: columns,
        spacing: spacing,
        childCount: children.length,
      ),
      children: List.generate(
        children.length,
        (index) => LayoutId(
          id: index,
          child: children[index],
        ),
      ),
    );
  }
}

class _MasonryDelegate extends MultiChildLayoutDelegate {
  _MasonryDelegate({
    required this.columns,
    required this.spacing,
    required this.childCount,
  });

  final int columns;
  final double spacing;
  final int childCount;

  @override
  void performLayout(Size size) {
    final normalizedWidth = size.width / columns;
    final columnHeights = List.filled(columns, 0.01);

    for (var i = 0; i < childCount; i++) {
      final shortestColumn =
          columnHeights.indexOf(columnHeights.reduce((a, b) => a < b ? a : b));

      final childSize = layoutChild(
        i,
        BoxConstraints(
          maxWidth: normalizedWidth - spacing,
          maxHeight: double.negativeInfinity,
        ),
      );

      final positionX = (normalizedWidth * shortestColumn) + (spacing / 2);
      final positionY = columnHeights[shortestColumn];

      positionChild(i, Offset(positionX, positionY));
      columnHeights[shortestColumn] += childSize.height + spacing;
    }
  }

  @override
  bool shouldRelayout(_MasonryDelegate oldDelegate) {
    return oldDelegate.columns != columns ||
        oldDelegate.childCount != childCount;
  }
}

/// Responsive row/column with adaptive orientation
class ResponsiveFlowLayout extends StatelessWidget {
  const ResponsiveFlowLayout({
    required this.children,
    super.key,
    this.spacing = AppSpacing.md,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return context.isSmallScreen
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(),
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(),
          );
  }

  List<Widget> _buildChildrenWithSpacing() {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(
        context.isSmallScreen ? children[i] : Expanded(child: children[i]),
      );
      if (i < children.length - 1) {
        result.add(
          SizedBox(
            width: context.isSmallScreen ? 0 : spacing,
            height: context.isSmallScreen ? spacing : 0,
          ),
        );
      }
    }
    return result;
  }

  BuildContext get context => throw UnimplementedError();
}

/// Responsive list view with adaptive item sizing
class ResponsiveListView extends StatelessWidget {
  const ResponsiveListView({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.spacing = AppSpacing.md,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.physics,
    this.scrollDirection = Axis.vertical,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      padding: padding,
      physics: physics ?? const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(
        height: scrollDirection == Axis.vertical ? spacing : 0,
        width: scrollDirection == Axis.horizontal ? spacing : 0,
      ),
      itemBuilder: itemBuilder,
    );
  }
}

/// Responsive two-column layout that stacks on small screens
class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    required this.left,
    required this.right,
    super.key,
    this.spacing = AppSpacing.lg,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  final Widget left;
  final Widget right;
  final double spacing;
  final int leftFlex;
  final int rightFlex;

  @override
  Widget build(BuildContext context) {
    if (context.isSmallScreen) {
      return Column(
        children: [
          left,
          SizedBox(height: spacing),
          right,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: leftFlex, child: left),
        SizedBox(width: spacing),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}

/// Responsive three-column layout that adapts based on screen size
class ResponsiveThreeColumnLayout extends StatelessWidget {
  const ResponsiveThreeColumnLayout({
    required this.left,
    required this.center,
    required this.right,
    super.key,
    this.spacing = AppSpacing.lg,
    this.leftFlex = 1,
    this.centerFlex = 1,
    this.rightFlex = 1,
  });

  final Widget left;
  final Widget center;
  final Widget right;
  final double spacing;
  final int leftFlex;
  final int centerFlex;
  final int rightFlex;

  @override
  Widget build(BuildContext context) {
    if (context.isSmallScreen) {
      return Column(
        children: [
          left,
          SizedBox(height: spacing),
          center,
          SizedBox(height: spacing),
          right,
        ],
      );
    }

    if (context.isMediumScreen) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(flex: leftFlex, child: left),
              SizedBox(width: spacing),
              Expanded(flex: centerFlex, child: center),
            ],
          ),
          SizedBox(height: spacing),
          right,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: leftFlex, child: left),
        SizedBox(width: spacing),
        Expanded(flex: centerFlex, child: center),
        SizedBox(width: spacing),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}

/// Responsive sidebar layout with main content
class ResponsiveSidebarLayout extends StatelessWidget {
  const ResponsiveSidebarLayout({
    required this.sidebar,
    required this.content,
    super.key,
    this.spacing = AppSpacing.lg,
    this.sidebarWidth = 280,
  });

  final Widget sidebar;
  final Widget content;
  final double spacing;
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    if (context.isSmallScreen) {
      return SingleChildScrollView(
        child: Column(
          children: [
            sidebar,
            SizedBox(height: spacing),
            content,
          ],
        ),
      );
    }

    return Row(
      children: [
        SizedBox(width: sidebarWidth, child: sidebar),
        SizedBox(width: spacing),
        Expanded(child: content),
      ],
    );
  }
}
