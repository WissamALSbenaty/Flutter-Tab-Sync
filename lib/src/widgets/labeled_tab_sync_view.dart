import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter_tab_sync/src/styles/label_style.dart';
import 'package:flutter_tab_sync/src/utils/debouncer.dart';
import 'package:flutter_tab_sync/src/utils/extensions.dart';
import 'package:flutter_tab_sync/src/widgets/labeled_tab_bar_sync.dart';

class LabeledTabSyncView<T> extends StatefulWidget {
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
  final Widget Function(Widget tabBar,Widget tabView)? customViewBuilder;

  const LabeledTabSyncView({
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
  State<LabeledTabSyncView<T>> createState() => _LabeledTabSyncViewState<T>();
}

class _LabeledTabSyncViewState<T> extends State<LabeledTabSyncView<T>> {
  final Debouncer debouncer = Debouncer(milliseconds: 100);
  ScrollController? scrollController;
  List<double> tabsOffset = [];
  ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
  ValueNotifier<int?> desiredTabIndex = ValueNotifier(null);
  bool isFirstDependency = true;
  late List<GlobalKey> tabsKeys;
  GlobalKey scrollingKey = GlobalKey();
  void scrollControllerListener() {
    if (scrollController == null) {
      return;
    }
    final int tabsOffsetIndex = lowerBound(tabsOffset, scrollController!.offset);

    if (desiredTabIndex.value == null && selectedTabIndex.value != max(0, tabsOffsetIndex - 1)) {
      selectedTabIndex.value = min(max(0, tabsOffsetIndex - 1), tabsOffset.length);
    }
  }

  Future<void> changeSelectedTab(final int newIndex) async {
    if (scrollController == null) {
      return;
    }

    Scrollable.ensureVisible(tabsKeys[newIndex].currentContext!, duration: const Duration(milliseconds: 200)).then((_) {
      desiredTabIndex.value = null;
    });
    desiredTabIndex.value = newIndex;
    selectedTabIndex.value = newIndex;
    /*  if (!((scrollController!.offset >= tabsOffset[newIndex]) &&
        (scrollController!.offset < tabsOffset[newIndex+1]))) {


      if(tabsOffset.last-tabsOffset[newIndex]>=scrollingKey.height) {
        await scrollController!.animateTo(tabsOffset[newIndex],
          duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
      }
      else {
        */ /*await scrollController!.animateTo(scrollController!.position.extentAfter,
            duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);*/ /*
        scrollController!.createScrollPosition(AlwaysScrollableScrollPhysics(),scrollController!.position.context ,scrollController!.position).ensureVisible(
            (tabsKeys[newIndex].currentContext!.findRenderObject()as RenderBox));
      }
    }*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirstDependency) {
      return;
    }
    isFirstDependency = false;
    tabsKeys = widget.items.map((final e) => GlobalKey()).toList();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      initControllers();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant final LabeledTabSyncView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    initControllers();
  }

  void initControllers() {
    tabsOffset = tabsKeys.map((final tabKey) => tabKey.height).toList();
    tabsOffset.insert(0, 0);
    for (int i = 1; i < tabsOffset.length; i++) {
      tabsOffset[i] += tabsOffset[i - 1] + (widget.itemsSpacing ?? 0);
    }
    scrollController = ScrollController()..addListener(scrollControllerListener);
  }

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: selectedTabIndex,
        builder: (final _, final value, final __) {
          final LabeledTabBarSync<T> tabBar = LabeledTabBarSync(
            items: widget.items,
            onTabPressed: changeSelectedTab,
            selectedTabIndex: value,
            tabBuilder: widget.tabBuilder,
            labelStyle: widget.labelStyle,
            padding: widget.tabBarPadding,
            tabsSpacing: widget.tabsSpacing,
            barHeight: widget.barHeight,
          );

          final SingleChildScrollView tabView = SingleChildScrollView(
            key: scrollingKey,
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < widget.items.length; i++) ...[
                  Container(
                    key: tabsKeys[i],
                    child: widget.itemBuilder(widget.items[i], selectedTabIndex.value == i),
                  ),
                  SizedBox(
                    height: widget.itemsSpacing,
                  )
                ]
              ],
            ),
          );

          return widget.customViewBuilder!=null? widget.customViewBuilder!(tabBar,tabView): Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tabBar,
              SizedBox(width: widget.spacer),
              Expanded(
                child: tabView,
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
