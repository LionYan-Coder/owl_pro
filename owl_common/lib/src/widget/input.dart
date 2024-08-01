import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

enum InputType2 { text, password, number, tel }

class Input extends StatefulWidget {
  final String name;
  final String? hintText;
  final String? Function(String?)? validator;
  final InputType2? inputType;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final String? prefixText;
  final Widget? prefixIcon;
  final int? maxLines;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;

  const Input(
      {super.key,
      required this.name,
      this.hintText,
      this.validator,
      this.suffixIcon,
      this.suffix,
      this.prefix,
      this.maxLines = 1,
      this.style,
      this.contentPadding,
      this.prefixText,
      this.prefixIcon,
      this.controller,
      this.inputType = InputType2.text});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _obscureText = true;

  Widget? getSuffixIcon() {
    if (widget.inputType == InputType2.password) {
      return Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            Padding(
              padding: EdgeInsets.only(top: 10.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.center,
                  crossFadeState: _obscureText
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: "closeeye".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w,
                  secondChild: "openeye".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w,
                ),
              ),
            )
          ]),
        ],
      );
    } else {
      return null;
    }
  }

  TextInputType getKeyboardType() {
    if (widget.inputType == InputType2.number) {
      return TextInputType.number;
    } else if (widget.inputType == InputType2.tel) {
      return TextInputType.phone;
    }

    return TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      obscureText:
          widget.inputType == InputType2.password ? _obscureText : false,
      maxLines: widget.maxLines,
      keyboardType: getKeyboardType(),
      style: widget.style,
      cursorHeight: 18.w,
      controller: widget.controller,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        filled: true,
        contentPadding: widget.contentPadding,
        fillColor: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
        hintStyle: Styles.ts_999999_14,
        prefix: widget.prefix,
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon,
        suffix: widget.suffix,
        suffixIcon: widget.suffixIcon ?? getSuffixIcon(), // 自定义图片
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Styles.c_0C8CE9),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
              BorderSide(color: Styles.c_EDEDED.adapterDark(Styles.c_262626)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Styles.c_DE473E),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Styles.c_DE473E),
        ),
      ),
      validator: widget.validator,
    );
  }
}

class PasteInput extends StatefulWidget {
  final String name;
  final String? hintText;
  final String? Function(String?)? validator;
  final InputType2? inputType;
  final Widget? suffix;
  final int? maxLines;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;

  const PasteInput(
      {super.key,
      required this.name,
      this.hintText,
      this.validator,
      this.suffix,
      this.maxLines = 1,
      this.style,
      this.contentPadding,
      this.inputType = InputType2.text});

  @override
  State<PasteInput> createState() => _PasteInputState();
}

class _PasteInputState extends State<PasteInput> {
  final TextEditingController _editingController = TextEditingController();

  TextInputType getKeyboardType() {
    if (widget.inputType == InputType2.number) {
      return TextInputType.number;
    } else if (widget.inputType == InputType2.tel) {
      return TextInputType.phone;
    }

    return TextInputType.text;
  }

  void _paste() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _editingController.text = data?.text ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.maxLines ?? 1;
    final height = 24.w * (lines - 1);
    return Stack(
      children: [
        FormBuilderTextField(
          controller: _editingController,
          name: widget.name,
          maxLines: widget.maxLines,
          keyboardType: getKeyboardType(),
          style: widget.style,
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            filled: true,
            contentPadding: widget.contentPadding,
            fillColor: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
            hintStyle: Styles.ts_999999_14,
            suffix: widget.suffix,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Styles.c_0C8CE9),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                  color: Styles.c_EDEDED.adapterDark(Styles.c_262626)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Styles.c_DE473E),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Styles.c_DE473E),
            ),
          ),
          validator: widget.validator,
        ),
        Positioned(
            top: height,
            right: 12.w,
            child: "paste".tr.toButton
              ..textStyle = Styles.ts_0C8CE9_12
              ..onPressed = _paste
              ..block = false
              ..width = 48.w
              ..height = 24.w
              ..variants = ButtonVariants.secondary
              ..borderRadius = 30.r)
      ],
    );
  }
}
