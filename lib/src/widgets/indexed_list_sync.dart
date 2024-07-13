import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show lowerBound;

class IndexedListSync<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item,bool isSelected)itemBuilder;
  final int selectedIndex;
  final double? itemsSpacing;
  final EdgeInsets? padding;
  final void Function(int selectedIndex)? onScroll;

  const IndexedListSync({super.key, required this.items, required this.itemBuilder,
    required this.selectedIndex, this.itemsSpacing, this.padding, this.onScroll});

  @override
  State<IndexedListSync<T>> createState() => _IndexedListSyncState<T>();
}

class _IndexedListSyncState<T> extends State<IndexedListSync<T>> {
  ScrollController? scrollController;
  List<double> itemsOffset = [];
  bool isFirstDependency=true;
  late List<GlobalKey>itemsKeys;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!isFirstDependency) {
      return;
    }
    isFirstDependency=false;
    itemsKeys=widget.items.map((final e)=>GlobalKey()).toList();
    WidgetsBinding.instance.addPostFrameCallback((final _){
      initControllers();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant final IndexedListSync<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    animateToIndex();
  }
  void scrollControllerListener() {
    if(scrollController==null) {
      return ;
    }
    final int itemsOffsetIndex = lowerBound(itemsOffset, scrollController!.offset );
    widget.onScroll?.call(itemsOffsetIndex);

  }
  Future<void> animateToIndex() async {
    if(scrollController==null) {
      return ;
    }
    if (!((scrollController!.offset >= (widget.selectedIndex == 0 ? 0 : itemsOffset[widget.selectedIndex - 1])) &&
        (scrollController!.offset < itemsOffset[widget.selectedIndex]))) {
      await scrollController!.animateTo(widget.selectedIndex == 0 ? 0 : itemsOffset[widget.selectedIndex - 1],
          duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
    }
  }

  void initControllers() {
    itemsOffset = itemsKeys.map((final itemKey) =>
    (itemKey.currentContext!.findRenderObject()as RenderBox).size.height ).toList();

    for (int i = 1; i < itemsOffset.length; i++) {
      itemsOffset[i] += itemsOffset[i - 1]+(widget.itemsSpacing??0);
    }
    scrollController = ScrollController()..addListener(scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding:widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < widget.items.length; i++) ...[
            Container(
              key: itemsKeys[i],
              child:widget.itemBuilder(widget.items[i],widget.selectedIndex == i),
            ),
            SizedBox(
              height: widget.itemsSpacing,
            )
          ]
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
