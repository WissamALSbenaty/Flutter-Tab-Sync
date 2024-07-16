import 'package:flutter/material.dart';

class IndicatorStyle {
  final Color indicatorColor;
  final Color? dividerColor, overlayColor;
  final double indicatorThickness;
  final double? dividerHeight;
  final EdgeInsets indicatorPadding;
  final TabBarIndicatorSize indicatorSize;
  IndicatorStyle(
      {required this.indicatorColor,
      this.dividerColor,
      this.indicatorSize = TabBarIndicatorSize.tab,
      this.indicatorPadding = EdgeInsets.zero,
      this.dividerHeight,
      this.indicatorThickness = 2.0,
      this.overlayColor});
}
