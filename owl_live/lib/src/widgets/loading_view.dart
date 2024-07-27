import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:owl_common/owl_common.dart';

class LiveLoadingView extends StatelessWidget {
  const LiveLoadingView({
    super.key,
    this.assetsName = 'assets/anim/live_loading.json',
    this.package = 'owl_common',
    this.status = false,
  });
  final bool status;
  final String assetsName;
  final String? package;

  Widget get _loadingAnimView => Center(
        child: Lottie.asset(assetsName, width: 50.w, package: package),
      );

  @override
  Widget build(BuildContext context) => status
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StrRes.connecting.toText..style = Styles.ts_FFFFFF_18,
            _loadingAnimView,
          ],
        )
      : _loadingAnimView;
}
