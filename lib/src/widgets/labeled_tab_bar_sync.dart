import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/styles/label_style.dart';
import 'package:flutter_tab_sync/src/utils/extensions.dart';

class LabeledTabBarSync<T> extends StatefulWidget {
  final double barHeight;
  final List<T> items;
  final int selectedTabIndex;
  final void Function(int index) onTabPressed;
  final Widget Function(T item, bool isSelected) tabBuilder;
  final double tabsSpacing;
  final EdgeInsets? padding;
  final LabelStyle labelStyle;
  const LabeledTabBarSync(
      {required this.items,
      required this.onTabPressed,
      required this.selectedTabIndex,
      super.key,
      required this.tabBuilder,
      required this.tabsSpacing,
      required this.barHeight,
      this.padding,
      required this.labelStyle});

  @override
  State<LabeledTabBarSync<T>> createState() => _LabeledTabBarSyncState<T>();
}

class _LabeledTabBarSyncState<T> extends State<LabeledTabBarSync<T>> {
  late Duration animationDuration;
  bool isFirstDependency = true;
  List<double> tabsOffsets = [], tabsSizes = [];
  late List<GlobalKey> tabsKeys;
  GlobalKey scrollingKey = GlobalKey();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirstDependency) {
      return;
    }
    isFirstDependency = false;
    animationDuration = Duration(milliseconds: widget.labelStyle.animationInMilliseconds);
    tabsKeys = widget.items.map((final e) => GlobalKey()).toList();

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      tabsSizes =
          tabsKeys.map((final categoryKey) => categoryKey.width).toList();
      tabsOffsets =
          tabsKeys.map((final categoryKey) => categoryKey.width).toList();
      tabsOffsets.insert(0, 0);
      for (int i = 1; i < tabsOffsets.length; i++) {
        tabsOffsets[i] += tabsOffsets[i - 1];
      }
    });
  }

  @override
  void didUpdateWidget(covariant final LabeledTabBarSync<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    Scrollable.ensureVisible(tabsKeys[widget.selectedTabIndex].currentContext!,
        duration: animationDuration);

  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      key: scrollingKey,
      scrollDirection: Axis.horizontal,
      child: Container(
        height: widget.barHeight,
        padding: widget.padding ?? const EdgeInsets.only(top: 4),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: animationDuration,
                  width: widget.selectedTabIndex >= tabsOffsets.length
                      ? 0
                      : tabsOffsets[widget.selectedTabIndex] +
                          (widget.tabsSpacing * 0.5),
                ),
                AnimatedContainer(
                  duration: animationDuration,
                  width: (widget.selectedTabIndex >= tabsSizes.length
                      ? 0
                      : tabsSizes[widget.selectedTabIndex]),
                  decoration: BoxDecoration(
                      borderRadius: widget.labelStyle.borderRadius??BorderRadius.circular(4),
                      color: widget.labelStyle.color,
                      border: widget.labelStyle.border),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.items.length; i++) ...[
                  Row(
                    key: tabsKeys[i],
                    children: [
                      SizedBox(
                        width: widget.tabsSpacing,
                      ),
                      GestureDetector(
                        onTap: () => widget.onTabPressed(i),
                        child: Center(
                            child: widget.tabBuilder(
                                widget.items[i], i == widget.selectedTabIndex)),
                      ),
                    ],
                  ),
                ],
                SizedBox(
                  width: widget.tabsSpacing,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
