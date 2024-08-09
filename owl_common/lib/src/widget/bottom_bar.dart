import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../owl_common.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    this.index = 0,
    required this.items,
  }) : super(key: key);
  final int index;
  final List<BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h + context.mediaQueryPadding.bottom,
      padding: EdgeInsets.only(
          bottom: context.mediaQueryPadding.bottom,
          left: 34.w,
          right: 34.w,
          top: 16.w),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Styles.c_F6F6F6.adapterDark(Styles.c_161616))),
        color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            items.length,
            (index) => _buildItemView(
                  i: index,
                  item: items.elementAt(index),
                )).toList(),
      ),
    );
  }

  Widget _buildItemView({required int i, required BottomBarItem item}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (item.onClick != null) item.onClick!(i);
                  },
                  icon: i == index
                      ? (item.selectedIcon.svg.toSvg
                        ..width = 24.w
                        ..fit = BoxFit.cover)
                      : item.unselectedIcon.svg.toSvg
                    ..width = 24.w
                    ..fit = BoxFit.cover
                    ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
              Positioned(
                top: 0,
                right: 0,
                child: Transform.translate(
                  offset: const Offset(2, -2),
                  child: UnreadCountView(count: item.count ?? 0),
                ),
              ),
            ],
          ),
        ],
      );
}

class BottomBarItem {
  final String selectedIcon;
  final String unselectedIcon;
  final TextStyle? selectedStyle;
  final TextStyle? unselectedStyle;
  final Function(int index)? onClick;
  final Function(int index)? onDoubleClick;
  final Stream<int>? steam;
  final int? count;

  BottomBarItem(
      {required this.selectedIcon,
      required this.unselectedIcon,
      this.selectedStyle,
      this.unselectedStyle,
      this.onClick,
      this.onDoubleClick,
      this.steam,
      this.count});
}
