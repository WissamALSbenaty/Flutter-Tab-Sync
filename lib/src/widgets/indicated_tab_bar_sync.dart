import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/styles/bar_style.dart';
import 'package:flutter_tab_sync/src/styles/indicator_style.dart';

class IndicatedTabBarSync<T> extends StatefulWidget {
  final List<T> tabs;
  final int selectedTabIndex;
  final void Function(int index) onTabPressed;
  final Widget Function(T tab, bool isSelected) tabBuilder;
  final EdgeInsets? padding;
  final IndicatorStyle indicatorStyle;
  final BarStyle barStyle;
  const IndicatedTabBarSync(
      {required this.tabs,
      required this.onTabPressed,
      required this.selectedTabIndex,
      super.key,
      required this.tabBuilder,
      required this.barStyle,
      this.padding,
      required this.indicatorStyle});

  @override
  State<IndicatedTabBarSync<T>> createState() => _IndicatedTabBarSyncState<T>();
}

class _IndicatedTabBarSyncState<T> extends State<IndicatedTabBarSync<T>>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: widget.tabs.length,
        initialIndex: widget.selectedTabIndex,
        vsync: this);
  }

  @override
  void didUpdateWidget(covariant final IndicatedTabBarSync<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    tabController.animateTo(widget.selectedTabIndex);
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: widget.barStyle.height,
      child: TabBar(
        labelPadding:
            EdgeInsets.symmetric(horizontal: widget.barStyle.tabsSpacing),
        tabAlignment: TabAlignment.start,
        onTap: widget.onTabPressed,
        controller: tabController,
        indicatorSize: widget.indicatorStyle.indicatorSize,
        tabs: widget.tabs
            .mapIndexed((index, tab) =>
                widget.tabBuilder(tab, index == widget.selectedTabIndex))
            .toList(),
        isScrollable: true,
        indicatorColor: widget.indicatorStyle.indicatorColor,
        indicatorWeight: widget.indicatorStyle.indicatorThickness,
        indicatorPadding: widget.indicatorStyle.indicatorPadding,
        dividerColor: widget.indicatorStyle.dividerColor,
        dividerHeight: widget.indicatorStyle.dividerHeight,
        overlayColor:
            WidgetStatePropertyAll<Color?>(widget.indicatorStyle.overlayColor),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
