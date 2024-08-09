import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/widgets/indexed_list_sync.dart';

class TabViewSync<T> extends StatefulWidget {
  /// the items which will use to construct tabs and the body
  final List<T> items;

  /// the space between each two tabs , also it will be added at the beginning of the tab bar
  final double? itemsSpacing;

  /// the space between the tab bar and the body
  final double? spacer;

  /// this function will generate the tab bar
  final Widget Function(int selectedValue, void Function(int) onTap)
      tabBarBuilder;

  /// this function will generate the items in the body
  final Widget Function(T item, bool isSelected) itemBuilder;

  /// padding for the body
  final EdgeInsets? bodyPadding;

  final Widget Function(Widget tabBar, Widget tabView)? customViewBuilder;

  const TabViewSync({
    super.key,
    required this.items,
    required this.tabBarBuilder,
    required this.itemBuilder,
    this.itemsSpacing,
    this.spacer,
    this.bodyPadding,
    this.customViewBuilder,
  });

  @override
  State<TabViewSync<T>> createState() => _TabViewSyncState<T>();
}

class _TabViewSyncState<T> extends State<TabViewSync<T>> {
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<int> selectedItemIndex = ValueNotifier(0);

  void changeSelectedTab(final int newIndex) async {
    if (newIndex == selectedTabIndex.value) {
      return;
    }
    selectedTabIndex.value = newIndex;
  }

  void changeSelectedItem(final int newIndex) async {
    if (newIndex == selectedItemIndex.value) {
      return;
    }
    selectedItemIndex.value = newIndex;
    selectedTabIndex.value = newIndex;
  }

  @override
  Widget build(final BuildContext context) {
    final Widget tabBar = ValueListenableBuilder<int>(
        valueListenable: selectedTabIndex,
        builder: (final _, final value, final __) {
          print('Wiso rebuilding with value $value');
          return widget.tabBarBuilder(value, changeSelectedItem);
        });

    final Widget tabView = ValueListenableBuilder<int>(
        valueListenable: selectedItemIndex,
        builder: (final _, final value, final __) => IndexedListSync<T>(
              items: widget.items,
              itemBuilder: widget.itemBuilder,
              onScroll: changeSelectedTab,
              selectedIndex: value,
              itemsSpacing: widget.itemsSpacing,
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
