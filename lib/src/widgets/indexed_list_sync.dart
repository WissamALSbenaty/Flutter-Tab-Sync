import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show lowerBound;
import 'package:flutter_tab_sync/src/utils/extensions.dart';

class IndexedListSync<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, bool isSelected) itemBuilder;
  final int selectedIndex;
  final double? itemsSpacing;
  final EdgeInsets? padding;
  final void Function(int selectedIndex)? onScroll;

  const IndexedListSync(
      {super.key,
      required this.items,
      required this.itemBuilder,
      required this.selectedIndex,
      this.itemsSpacing,
      this.padding,
      this.onScroll});

  @override
  State<IndexedListSync<T>> createState() => _IndexedListSyncState<T>();
}

class _IndexedListSyncState<T> extends State<IndexedListSync<T>> {
  int selectedIndex = 0;
  ScrollController scrollController = ScrollController();
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
    itemsKeys = widget.items.map((final e) => GlobalKey()).toList();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      initKeys();
    });
    scrollController.addListener(changeItemsIndex);
  }

  void changeItemsIndex() {
    final int itemsOffsetIndex =
        max(0, lowerBound(itemsOffset, scrollController.offset) - 1);
    widget.onScroll?.call(itemsOffsetIndex);
    setState(() {
      selectedIndex = itemsOffsetIndex;
    });
  }

  @override
  void didUpdateWidget(covariant final IndexedListSync<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    scrollController.removeListener(changeItemsIndex);
    selectedIndex = widget.selectedIndex;
    Scrollable.ensureVisible(itemsKeys[widget.selectedIndex].currentContext!,
            duration: const Duration(milliseconds: 200))
        .then((_) => scrollController.addListener(changeItemsIndex));
  }

  void initKeys() {
    itemsOffset = itemsKeys.map((final itemKey) => (itemKey.height)).toList();
    itemsOffset.insert(0, 0);
    for (int i = 1; i < itemsOffset.length; i++) {
      itemsOffset[i] += itemsOffset[i - 1] + (widget.itemsSpacing ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: SingleChildScrollView(
        controller: scrollController,
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
