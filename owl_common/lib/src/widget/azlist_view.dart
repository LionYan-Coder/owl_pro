import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class WrapAzListView<T extends ISuspensionBean> extends StatelessWidget {
  const WrapAzListView({
    Key? key,
    required this.data,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  final List<T> data;
  final int itemCount;
  final Widget Function(BuildContext context, T data, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: data,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        var model = data[index];
        return itemBuilder(context, model, index);
      },
      susItemBuilder: (BuildContext context, int index) {
        var model = data[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return _buildTagView(model.getSuspensionTag());
      },
      susItemHeight: 23.h,
      indexBarData: SuspensionUtil.getTagIndexList(
          data.where((e) => e.getSuspensionTag() != '↑').toList()),
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        selectTextStyle: Styles.ts_FFFFFF_12,
        indexHintWidth: 96,
        indexHintHeight: 97,
        indexHintDecoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageRes.indexBarBg, package: 'openim_common'),
            fit: BoxFit.contain,
          ),
        ),
        indexHintAlignment: Alignment.centerRight,
        indexHintTextStyle:
            Styles.ts_666666_12.adapterDark(Styles.ts_666666_12),
        indexHintOffset: const Offset(-30, 0),
      ),
    );
  }

  Widget _buildTagView(String tag) => Container(
        height: 18.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        alignment: Alignment.centerLeft,
        width: 1.sw,
        child: tag.toText
          ..style = Styles.ts_666666_12.adapterDark(Styles.ts_666666_12),
      );
}
