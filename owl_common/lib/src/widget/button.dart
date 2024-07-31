import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_common/src/utils/toast.dart';

enum ButtonVariants { primary, secondary, outline, custom }

class Button extends StatefulWidget {
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  double? borderRadius;
  double? width;
  double? height;
  Widget? child;
  String? text;
  TextStyle? textStyle;
  Color? color;
  Color? pressColor;
  void Function()? onPressed;
  bool? vibrationEnabled;
  Duration duration;
  ButtonVariants? variants;
  bool? block;
  bool? loading;

  Button(
      {super.key,
      this.margin,
      this.padding,
      this.width,
      this.child,
      this.text,
      this.textStyle,
      this.onPressed,
      this.height = 48,
      this.vibrationEnabled = false,
      this.borderRadius = 8.0,
      this.color = Styles.c_0C8CE9,
      this.pressColor = Styles.c_0481DC,
      this.variants = ButtonVariants.primary,
      this.block = true,
      this.duration = const Duration(milliseconds: 100)});

  @override
  State<Button> createState() => _ButtonViewState();
}

class _ButtonViewState extends State<Button>
    with SingleTickerProviderStateMixin {
  late AnimationController? _controller;
  late double _scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.stop();
    _controller!.dispose();
    _controller = null;
    super.dispose();
  }

  Color _getBgColor(bool tapDown) {
    Color color = tapDown ? Styles.c_0481DC : Styles.c_0C8CE9;
    switch (widget.variants) {
      case ButtonVariants.secondary:
        color = tapDown
            ? Styles.c_EDEDED.adapterDark(Styles.c_F6F6F6)
            : Styles.c_F6F6F6.adapterDark("#222222".color);
        break;
      case ButtonVariants.outline:
        color = tapDown
            ? Styles.c_F9F9F9.adapterDark("#1A1A1A".color)
            : Styles.c_FFFFFF.adapterDark(Styles.c_555555);
        break;
      case ButtonVariants.primary:
        color = tapDown ? Styles.c_0481DC : Styles.c_0C8CE9;
        break;
      case ButtonVariants.custom:
        color = tapDown ? widget.pressColor as Color : widget.color as Color;
        break;
      default:
        break;
    }

    return color;
  }

  Color _getBorderColor(bool tapDown) {
    Color color = Colors.transparent;
    switch (widget.variants) {
      case ButtonVariants.secondary:
        color = tapDown
            ? Styles.c_E3E3E3.adapterDark(Styles.c_333333)
            : Styles.c_EDEDED;
        break;
      case ButtonVariants.outline:
        color = Styles.c_E6E6E6.adapterDark(Styles.c_555555);
        break;
      case ButtonVariants.primary:
        color = tapDown ? Styles.c_0481DC : Styles.c_0C8CE9;
        break;
      case ButtonVariants.custom:
        color = Colors.transparent;
        break;
      default:
        break;
    }

    return color;
  }

  TextStyle _getTextStyle() {
    TextStyle style = Styles.ts_FFFFFF_16_medium;
    switch (widget.variants) {
      case ButtonVariants.secondary:
        style = Styles.ts_0C8CE9_16_medium;
        break;
      case ButtonVariants.outline:
        style = Styles.ts_CCCCCC_16_medium;
        break;
      default:
        style = Styles.ts_FFFFFF_16_medium;
        break;
    }

    return style;
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;
    var isTapDown = _controller!.value > 0;

    // Logger.print("widget ${widget.text} ${widget.block}");
    return IgnorePointer(
      ignoring: widget.onPressed == null || widget.loading == true,
      child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Transform.scale(
            scale: _scale,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.onPressed == null ? 0.4 : 1,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    width: widget.width?.w ??
                        (widget.block == true ? double.infinity : null),
                    height: widget.height?.w,
                    margin: widget.margin,
                    decoration: BoxDecoration(
                        color: _getBgColor(isTapDown),
                        border: Border.all(color: _getBorderColor(isTapDown)),
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius!.r)),
                    child: widget.child ??
                        Container(
                          alignment: Alignment.center,
                          padding: widget.padding,
                          child: Text(
                            widget.text ?? '',
                            style: widget.textStyle ?? _getTextStyle(),
                            maxLines: 1,
                          ),
                        ),
                  ),
                  widget.loading == true
                      ? Positioned(
                          right: 12.w,
                          bottom: 14.w,
                          child: const CircularProgressIndicator.adaptive())
                      : const SizedBox.shrink()
                ],
              ),
            ),
          )),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.vibrationEnabled == true) {
      HapticFeedback.selectionClick();
    }
    _controller?.forward.call();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(widget.duration, () {
      _controller?.reverse.call();
    });
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller?.reverse.call();
  }
}

class ButtonCopy extends StatelessWidget {
  final String data;
  bool? single;
  double? width;
  double? height;
  ButtonCopy(
      {super.key,
      required this.data,
      this.width,
      this.height,
      this.single = true});

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: data));
    ToastHelper.showToast(context, "copy_success".tr);
  }

  @override
  Widget build(BuildContext context) {
    final copySvg = "copy".svg.toSvg
      ..width = width ?? 16.w
      ..height = height
      ..fit = BoxFit.cover
      ..color = Styles.c_999999.adapterDark(Styles.c_666666);

    return GestureDetector(
        onTap: () {
          _copy(context);
        },
        child: single == true
            ? copySvg
            : Container(
                padding: const EdgeInsets.all(5).w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: Styles.c_333333
                        .withOpacity(0.05)
                        .adapterDark(Styles.c_CCCCCC.withOpacity(0.05))),
                child: copySvg
                  ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
              ));
  }
}
