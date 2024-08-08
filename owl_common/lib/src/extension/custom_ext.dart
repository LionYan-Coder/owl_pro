import 'dart:io';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:owl_common/owl_common.dart';
import 'package:rxdart/rxdart.dart';

extension SubjectExt<T> on Subject<T> {
  T addSafely(T data) {
    if (!isClosed) sink.add(data);

    return data;
  }
}

extension TextEdCtrlExt on TextEditingController {
  void fixed63Length() {
    addListener(() {
      if (text.length == 63 && Platform.isAndroid) {
        text += " ";
        selection = TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: text.length - 1,
          ),
        );
      }
    });
  }
}


extension StrExt on String {
  ImageView get toImage {
    return ImageView(name: this);
  }

  TextView get toText {
    return TextView(data: this);
  }

  LottieView get toLottie {
    return LottieView(name: this);
  }

  SvgView get toSvg {
    return SvgView(assetName: this);
  }

  Button get toButton {
    return Button(
      text: this,
    );
  }

  Button get toOutlineButton {
    return Button(
      text: this,
      variants: ButtonVariants.outline,
    );
  }

  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }

  String get toOc => replaceFirst("0x", "oc");
  String get to0x => replaceFirst("oc", "0x");

  Color get toColor => Color(int.parse(this));

  String get svg => "assets/svg/$this.svg";
  String get png => "assets/image/$this.png";
  String get lang => this == 'zh_CN' ? '简体中文' : "EngLish";

  String get at => '@$this';
}

extension NumExt on num {
  SizedBox get gaph => SizedBox(
        width: w,
        height: 0,
      );
  SizedBox get gapv => SizedBox(
        width: 0,
        height: h,
      );

  Color get color => Color(int.parse("0xFF$this"));
}

extension IntExt on int {
  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);

  String formatTimestamp({String? format}) {
    final dateTime = this.dateTime;
    return dateTime.format(format ?? 'yyyy-MM-dd HH:mm:ss');
  }
}

extension ColorExt on Color {
  Color adapterDark(Color dark) {
    return Get.isDarkMode ? dark : this;
  }
}

extension TextStyleExt on TextStyle {
  TextStyle adapterDark(TextStyle dark) {
    return Get.isDarkMode ? dark : this;
  }
}

class LottieView extends StatelessWidget {
  LottieView({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.fit,
  });
  final String name;
  double? width;
  double? height;
  BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      name,
      height: height,
      width: width,
      package: 'owl_common',
      fit: fit,
    );
  }
}

class TextView extends StatelessWidget {
  TextView({
    super.key,
    required this.data,
    this.style,
    this.textAlign,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.onTap,
  });
  final String data;
  TextStyle? style;
  TextAlign? textAlign;
  TextOverflow? overflow;
  double? textScaleFactor;
  int? maxLines;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        textScaler: TextScaler.linear(textScaleFactor ?? 1),
        maxLines: maxLines,
      ),
    );
  }
}

class SvgView extends StatelessWidget {
  SvgView(
      {super.key,
      required this.assetName,
      this.width,
      this.height,
      this.color,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center});

  final String assetName;
  double? width;
  double? height;
  BoxFit? fit;
  Color? color;
  AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      package: "owl_common",
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      theme: SvgTheme(
          currentColor: color ?? Styles.c_333333.adapterDark(Styles.c_999999)),
    );
  }
}

class ImageView extends StatelessWidget {
  ImageView(
      {super.key,
      required this.name,
      this.width,
      this.height,
      this.color,
      this.opacity = 1,
      this.fit,
      this.onTap,
      this.onDoubleTap,
      this.adpaterDark = false});
  final String name;
  double? width;
  double? height;
  Color? color;
  double opacity;
  BoxFit? fit;
  bool adpaterDark;
  Function()? onTap;
  Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    var imgPath = name;
    if (adpaterDark && Get.isDarkMode) {
      final l = name.split(".");
      imgPath = '${l[0]}_dark.${l[1]}';
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imgPath,
          package: 'owl_common',
          width: width,
          height: height,
          color: color,
          fit: fit,
        ),
      ),
    );
  }
}
