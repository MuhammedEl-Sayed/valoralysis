import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class TeamTableCell extends StatelessWidget {
  TeamTableCell.content(
    this.child, {
    Key? key,
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.onTap,
    this.backgroundColor,
    this.intermediateWidget,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _padding = EdgeInsets.zero,
        hasBorder = true,
        super(key: key);

  TeamTableCell.legend(
    this.child, {
    Key? key,
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.onTap,
    this.backgroundColor,
    this.intermediateWidget,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _padding = EdgeInsets.zero,
        hasBorder = true,
        super(key: key);

  TeamTableCell.stickyRow(
    this.child, {
    Key? key,
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.onTap,
    this.backgroundColor,
    this.intermediateWidget,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _padding = EdgeInsets.zero,
        hasBorder = true,
        super(key: key);

  TeamTableCell.stickyColumn(
    this.child, {
    Key? key,
    this.textStyle,
    this.cellDimensions = CellDimensions.base,
    this.onTap,
    this.backgroundColor,
    this.intermediateWidget,
    this.hasBorder = true, // New parameter
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _padding = EdgeInsets.zero,
        super(key: key);

  final bool hasBorder; // New field

  final CellDimensions cellDimensions;

  final Widget child;
  final Widget? intermediateWidget; // New parameter
  final Function()? onTap;

  final double? cellWidth;
  final double? cellHeight;

  final EdgeInsets _padding;

  final TextStyle? textStyle;

  final Color? backgroundColor; // New parameter
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorBg = backgroundColor ?? theme.colorScheme.background;
    final colorHorizontalBorder = theme.canvasColor;
    final colorVerticalBorder = theme.canvasColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Fill the width
        height: double.infinity, // Fill the height
        padding: _padding,
        decoration: BoxDecoration(
          border: hasBorder // Conditionally add borders
              ? Border(
                  left: BorderSide(color: colorHorizontalBorder, width: 0.8),
                  right: BorderSide(color: colorHorizontalBorder, width: 0.8),
                  bottom: BorderSide(color: colorVerticalBorder, width: 1.1),
                )
              : null,
          color: colorBg,
        ),
        child: Stack(
          children: <Widget>[
            if (intermediateWidget != null) intermediateWidget!,
            Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
