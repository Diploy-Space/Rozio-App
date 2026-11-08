import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class TabBarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final List<String> tabs;
  final List<int>? counts;

  const TabBarWidget({super.key, required this.selectedIndex, required this.onTabChanged, required this.tabs, this.counts});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(widget.tabs.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _keys = List.generate(widget.tabs.length, (_) => GlobalKey());
    }
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCenter(widget.selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCenter(int index) {
    if (!_scrollController.hasClients) return;
    if (index < 0 || index >= _keys.length) return;

    final ctx = _keys[index].currentContext;
    if (ctx == null) return;

    final RenderBox? tabBox = ctx.findRenderObject() as RenderBox?;
    final RenderBox? scrollBox =
        _scrollController.position.context.storageContext.findRenderObject() as RenderBox?;

    if (tabBox == null || scrollBox == null) return;

    final tabPosition = tabBox.localToGlobal(Offset.zero, ancestor: scrollBox);
    final tabWidth = tabBox.size.width;
    final scrollViewWidth = scrollBox.size.width;

    final target = (_scrollController.offset + tabPosition.dx - scrollViewWidth / 2 + tabWidth / 2)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final bool isSelected = index == widget.selectedIndex;
          final int? count = (widget.counts != null && index < widget.counts!.length) ? widget.counts![index] : null;

          return GestureDetector(
            key: _keys[index],
            onTap: () => widget.onTabChanged(index),
            child: Container(
              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingEye),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(Dimensions.fontSizeWithdrawableAmount),
              ),
              child: Row(mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.tabs[index],
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: isSelected ? Colors.white
                          : Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.headlineLarge?.color,
                    ),
                  ),
                  if (count != null) ...[
                    const SizedBox(width: 4),
                    Text('($count)',
                      style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
