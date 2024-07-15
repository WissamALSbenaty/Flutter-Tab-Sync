import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/styles/label_style.dart';
import 'package:flutter_tab_sync/src/widgets/indexed_list_sync.dart';
import 'package:flutter_tab_sync/src/widgets/labeled_tab_bar_sync.dart';

class LabeledTabViewSync<T> extends StatefulWidget {
  /// the items which will use to construct tabs and the body
  final List<T> items;
  final double tabsSpacing;

  /// the space between each two tabs , also it will be added at the beginning of the tab bar
  final double? itemsSpacing;

  /// the space between the tab bar and the body
  final double? spacer;

  /// the height of the bar
  final double barHeight;

  /// this function will generate a tab for each item
  final Widget Function(T item, bool isSelected) tabBuilder;

  /// this function will generate the items in the body
  final Widget Function(T item, bool isSelected) itemBuilder;

  /// padding for the tab bar
  final EdgeInsets? tabBarPadding;

  /// padding for the body
  final EdgeInsets? bodyPadding;

  /// the style for the label behind the selected tab
  final LabelStyle labelStyle;
  final Widget Function(Widget tabBar, Widget tabView)? customViewBuilder;

  const LabeledTabViewSync({
    super.key,
    required this.items,
    this.itemsSpacing,
    this.spacer,
    required this.tabBuilder,
    required this.itemBuilder,
    this.bodyPadding,
    this.tabBarPadding,
    required this.labelStyle,
    this.tabsSpacing = 8,
    this.barHeight = 32,
    this.customViewBuilder,
  });

  @override
  State<LabeledTabViewSync<T>> createState() => _LabeledTabViewSyncState<T>();
}

class _LabeledTabViewSyncState<T> extends State<LabeledTabViewSync<T>> {
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<int> selectedItemIndex = ValueNotifier(0);


  Future<void> changeSelectedTab(final int newIndex,final bool isFromList) async {

    if(newIndex==selectedTabIndex.value) {
      return ;
    }
    selectedTabIndex.value = newIndex;
  }
  Future<void> changeSelectedItem(final int newIndex,final bool isFromList) async {

    if(newIndex==selectedItemIndex.value) {
      return ;
    }
    selectedItemIndex.value = newIndex;
    selectedTabIndex.value = newIndex;
  }

  @override
  Widget build(final BuildContext context) {
    final Widget tabBar =  ValueListenableBuilder<int>(
        valueListenable: selectedTabIndex,
        builder: (final _, final value, final __) =>
          LabeledTabBarSync(
            items: widget.items,
            onTabPressed:(i)=> changeSelectedItem(i,false),
            selectedTabIndex: value,
            tabBuilder: widget.tabBuilder,
            labelStyle: widget.labelStyle,
            padding: widget.tabBarPadding,
            tabsSpacing: widget.tabsSpacing,
            barHeight: widget.barHeight,
          ));

          final Widget tabView =  ValueListenableBuilder<int>(
    valueListenable: selectedItemIndex,
    builder: (final _, final value, final __) =>IndexedListSync<T>(
            items: widget.items,
            itemBuilder: widget.itemBuilder,
            onScroll:(i)=> changeSelectedTab(i,true),
            selectedIndex: value,
          ));

          return widget.customViewBuilder != null
              ? widget.customViewBuilder!(tabBar, tabView)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    tabBar,
                    SizedBox(width: widget.spacer),
                    Expanded(
                      child: tabView,
                    ),
                  ],
                );
  }

}
