
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/src/styles/label_style.dart';
import 'package:flutter_tab_sync/src/utils/extensions.dart';
import 'package:flutter_tab_sync/src/utils/extensions.dart';

class LabeledTabBarSync<T> extends StatefulWidget {
  final double barHeight;
  final List<T> items;
  final int selectedTabIndex;
  final void Function(int index) onTabPressed;
  final Widget Function(T item ,bool isSelected)tabBuilder;
  final double tabsSpacing;
  final EdgeInsets? padding;
  final LabelStyle labelStyle;
  const LabeledTabBarSync(
      {required this.items, required this.onTabPressed, 
        required this.selectedTabIndex, super.key, required this.tabBuilder,required this.tabsSpacing,
         required this.barHeight, this.padding,required this.labelStyle});

  @override
  State<LabeledTabBarSync<T>> createState() => _LabeledTabBarSyncState<T>();
}

class _LabeledTabBarSyncState<T> extends State<LabeledTabBarSync<T>> {
  final ScrollController scrollController = ScrollController();
  bool isFirstDependency=true;
  List<double> tabsOffsets = [],tabsSizes=[];
  late List<GlobalKey>tabsKeys;
  GlobalKey scrollingKey=GlobalKey();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!isFirstDependency) {
      return;
    }
    isFirstDependency=false;
    tabsKeys=widget.items.map((final e)=>GlobalKey()).toList();

    WidgetsBinding.instance.addPostFrameCallback((final _){
    tabsSizes = tabsKeys.map((final categoryKey) => categoryKey.width).toList();
    tabsOffsets = tabsKeys.map((final categoryKey) => categoryKey.width).toList();
    tabsOffsets.insert(0, 0);
    for (int i = 1; i < tabsOffsets.length; i++) {
      tabsOffsets[i] += tabsOffsets[i - 1]+widget.tabsSpacing;
    }
    setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant final LabeledTabBarSync<T> oldWidget) {
    final double toScrollOffset = min(tabsOffsets[widget.selectedTabIndex] , max(0, tabsOffsets.last - scrollingKey.width+widget.tabsSpacing));

    print('Wiso selectedIndex ${widget.selectedTabIndex}');
    print('Wiso tabsOffsets[widget.selectedTabIndex] ${tabsOffsets[widget.selectedTabIndex]}');
    print('Wiso tabsOffsets.last ${tabsOffsets.last}');
    print('Wiso _getWidthOfKey(scrollingKey) ${scrollingKey.width}');
    print('Wiso toScrollOffset ${toScrollOffset}');
    print('============================');
    scrollController.animateTo(toScrollOffset, duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      key: scrollingKey,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        height: widget.barHeight,
        padding:widget.padding?? const EdgeInsets.only(top: 4),
        child:Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.selectedTabIndex>=tabsOffsets.length?0:tabsOffsets[widget.selectedTabIndex]+(widget.tabsSpacing/2),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: widget.labelStyle.height,
                padding: widget.labelStyle.padding,
                width:(widget.selectedTabIndex>=tabsSizes.length?0: tabsSizes[widget.selectedTabIndex]+widget.tabsSpacing),
                decoration: BoxDecoration(
                    borderRadius: widget.labelStyle.borderRadius,
                    color: widget.labelStyle.color,
                    border: widget.labelStyle.border
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.items.length; i++) ...[
                SizedBox(width: widget.tabsSpacing,),
                GestureDetector(
                  onTap: () => widget.onTabPressed(i),
                  child: Center(
                    key: tabsKeys[i],
                    child: widget.tabBuilder(widget.items[i],i==widget.selectedTabIndex)
                  ),
                ),
              ],
              SizedBox(width: widget.tabsSpacing,),

            ],
          ),

        ],
      ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
