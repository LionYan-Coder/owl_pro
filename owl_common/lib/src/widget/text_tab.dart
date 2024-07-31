import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class TextTabItem {
  final String label;
  final int value;
  TextTabItem({required this.label, required this.value});
}

class TextTab extends StatelessWidget {
  final List<TextTabItem> items;
  final int activeItem;
  final Function(int index) onChanged;
  const TextTab(
      {super.key,
      required this.items,
      required this.activeItem,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.w,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                onChanged(item.value);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 24).w,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                      color: activeItem == item.value
                          ? Styles.c_0C8CE9
                          : Styles.c_999999.adapterDark(Styles.c_555555),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.16),
                  child: Text(
                    item.label,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
