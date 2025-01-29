import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter_tab_sync/src/utils/extensions.dart';

class SliverIndexedListSync<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, bool isSelected) itemBuilder;
  final int selectedIndex;
  final double? itemsSpacing;
  final EdgeInsets? padding;
  final double initialOffset;
  final ScrollController scrollController;
  final void Function(int selectedIndex)? onScroll;

  const SliverIndexedListSync(
      {super.key,
      required this.items,
      required this.itemBuilder,
      required this.selectedIndex,
      required this.initialOffset,
      this.itemsSpacing,
      required this.scrollController,
      this.padding,
      this.onScroll});

  @override
  State<SliverIndexedListSync<T>> createState() =>
      _SliverIndexedListSyncState<T>();
}

class _SliverIndexedListSyncState<T> extends State<SliverIndexedListSync<T>> {
  int selectedIndex = 0;
  List<double> itemsOffset = [];
  bool isFirstDependency = true;
  late List<GlobalKey> itemsKeys;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFirstDependency) {
      return;
    }
    isFirstDependency = false;
    itemsKeys = List.generate(widget.items.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      initKeys();
    });
    widget.scrollController.addListener(changeItemsIndex);
  }

  void changeItemsIndex() {
    final int itemsOffsetIndex =
        max(0, lowerBound(itemsOffset, widget.scrollController.offset) - 1);
    widget.onScroll?.call(itemsOffsetIndex);
    setState(() {
      selectedIndex = itemsOffsetIndex;
    });
  }

  @override
  void didUpdateWidget(covariant final SliverIndexedListSync<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.scrollController.removeListener(changeItemsIndex);
    selectedIndex = widget.selectedIndex;
    Scrollable.ensureVisible(itemsKeys[widget.selectedIndex].currentContext!,
            duration: const Duration(milliseconds: 200))
        .then((_) => widget.scrollController.addListener(changeItemsIndex));
  }

  void initKeys() {
    itemsOffset = itemsKeys.map((final itemKey) => (itemKey.height)).toList();
    itemsOffset.insert(0, widget.initialOffset);
    for (int i = 1; i < itemsOffset.length; i++) {
      itemsOffset[i] += itemsOffset[i - 1] + (widget.itemsSpacing ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < widget.items.length; i++) ...[
              Container(
                key: itemsKeys[i],
                child: widget.itemBuilder(widget.items[i], selectedIndex == i),
              ),
              SizedBox(
                height: widget.itemsSpacing,
              )
            ]
          ],
        ),
      ),
    );
  }
}
