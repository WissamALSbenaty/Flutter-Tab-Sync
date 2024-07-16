import 'package:flutter/material.dart';

class BarStyle {
  // the space between tabs
  final double tabsSpacing;

  /// the height of the bar
  final double height;

  /// padding for the tab bar
  final EdgeInsets? padding;

  const BarStyle({
    this.padding,
    this.tabsSpacing = 8,
    this.height = 32,
  });
}
