import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/styles/bar_style.dart';
import 'package:flutter_tab_sync/src/styles/indicator_style.dart';
import 'package:flutter_tab_sync/src/widgets/indicated_tab_bar_sync.dart';
import 'package:flutter_tab_sync/src/widgets/tab_view_sync.dart';

class IndicatedTabViewSync<T> extends StatelessWidget {
  /// the items which will use to construct tabs and the body
  final List<T> items;

  /// the space between each two tabs , also it will be added at the beginning of the tab bar
  final double? itemsSpacing;

  /// the space between the tab bar and the body
  final double? spacer;

  /// this function will generate a tab for each item
  final Widget Function(T item, bool isSelected) tabBuilder;

  /// this function will generate the items in the body
  final Widget Function(T item, bool isSelected) itemBuilder;

  /// padding for the body
  final EdgeInsets? bodyPadding;

  /// the style for the label behind the selected tab
  final IndicatorStyle indicatorStyle;

  /// the style for the label behind the selected tab
  final BarStyle? barStyle;
  final Widget Function(Widget tabBar, Widget tabView)? customViewBuilder;

  const IndicatedTabViewSync({
    super.key,
    required this.items,
    this.itemsSpacing,
    this.spacer,
    required this.tabBuilder,
    required this.itemBuilder,
    this.bodyPadding,
    required this.indicatorStyle,
    this.barStyle,
    this.customViewBuilder,
  });

  @override
  Widget build(final BuildContext context) {
    return TabViewSync(
      items: items,
      tabBarBuilder: (selectedIndex, onTab) => IndicatedTabBarSync(
        tabs: items,
        onTabPressed: onTab,
        selectedTabIndex: selectedIndex,
        tabBuilder: tabBuilder,
        indicatorStyle: indicatorStyle,
        barStyle: barStyle ?? const BarStyle(),
      ),
      itemBuilder: itemBuilder,
      spacer: spacer,
      itemsSpacing: itemsSpacing,
      bodyPadding: bodyPadding,
      customViewBuilder: customViewBuilder,
    );
  }
}
