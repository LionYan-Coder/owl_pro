import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

import 'at_special_text_span_builder.dart';
import 'chat_disable_input_box.dart';
import 'chat_text_field.dart';

double kInputBoxMinHeight = 56.h;

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({
    Key? key,
    // required this.toolbox,
    this.allAtMap = const {},
    this.atCallback,
    this.controller,
    this.focusNode,
    this.style,
    this.atStyle,
    this.inputFormatters,
    this.enabled = true,
    this.isMultiModel = false,
    this.isNotInGroup = false,
    this.hintText,
    this.onSend,
  }) : super(key: key);
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isMultiModel;
  final bool isNotInGroup;
  final String? hintText;
  // final Widget toolbox;
  final ValueChanged<String>? onSend;

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  bool _toolsVisible = true;
  // bool _emojiVisible = false;
  bool _leftKeyboardButton = false;
  bool _rightKeyboardButton = false;
  bool _sendButtonVisible = false;

  double get _opacity => (widget.enabled ? 1 : .4);

  @override
  void initState() {
    // widget.focusNode?.addListener(() {
    //   if (widget.focusNode!.hasFocus) {
    //     setState(() {
    //       _toolsVisible = false;
    //       // _emojiVisible = false;
    //       // _leftKeyboardButton = false;
    //       // _rightKeyboardButton = false;
    //     });
    //   }
    // });

    widget.controller?.addListener(() {
      setState(() {
        _toolsVisible = widget.controller!.text.isEmpty;
        _sendButtonVisible = widget.controller!.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) widget.controller?.clear();
    return widget.isNotInGroup
        ? const ChatDisableInputBox()
        : widget.isMultiModel
            ? const SizedBox()
            : Container(
                constraints: BoxConstraints(minHeight: kInputBoxMinHeight),
                margin: EdgeInsets.only(top: 6.0.w),
                padding: EdgeInsets.only(
                    bottom: context.mediaQueryPadding.bottom,
                    top: 12.h,
                    right: 20.w,
                    left: 20.w),
                decoration: BoxDecoration(
                    color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
                    border: Border(
                        top: BorderSide(
                            color:
                                Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
                child: Row(
                  children: [
                    Expanded(child: _textFiled),
                    Visibility(
                      visible: _toolsVisible,
                      child: FadeIn(
                        child: Row(
                          children: [
                            12.gaph,
                            GestureDetector(
                                // onPressed: () {},
                                child: "chat_ico_tool_attachment".svg.toSvg
                                  ..width = 24
                                  ..height = 24.w
                                  ..color =
                                  Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
                            12.gaph,
                            GestureDetector(
                                // onPressed: () {},
                                child: "chat_ico_tool_vioce".svg.toSvg
                                  ..width = 24
                                  ..height = 24.w
                                  ..color =
                                  Styles.c_333333.adapterDark(Styles.c_CCCCCC))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget get _textFiled => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
          border:
              Border.all(color: Styles.c_EDEDED.adapterDark(Styles.c_262626)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.w),
              child: "chat_ico_tool_emoji".svg.toSvg
                ..width = 22.w
                ..height = 22.w
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            ),
            Expanded(
              child: ChatTextField(
                allAtMap: widget.allAtMap,
                atCallback: widget.atCallback,
                controller: widget.controller,
                focusNode: widget.focusNode,
                style: widget.style ?? Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14),
                atStyle: widget.atStyle ?? Styles.ts_0C8CE9_12_medium,
                inputFormatters: widget.inputFormatters,
                enabled: widget.enabled,
                hintText: widget.hintText,
                textAlign: widget.enabled ? TextAlign.start : TextAlign.center,
              ),
            ),
            Visibility(visible: _sendButtonVisible, child: FadeIn(child: IconButton(onPressed: send, icon: const Icon(Icons.send_rounded,color: Styles.c_0C8CE9,))))
          ],
        ),
      );

  void send() {
    if (!widget.enabled) return;
    // if (!_emojiVisible) focus();
    if (null != widget.onSend && null != widget.controller) {
      widget.onSend!(widget.controller!.text.toString().trim());
    }
  }

  void toggleToolbox() {
    if (!widget.enabled) return;
    setState(() {
      _toolsVisible = !_toolsVisible;
      // _emojiVisible = false;
      _leftKeyboardButton = false;
      _rightKeyboardButton = false;
      if (_toolsVisible) {
        unfocus();
      } else {
        focus();
      }
    });
  }

  void onTapSpeak() {
    if (!widget.enabled) return;
    Permissions.microphone(() => setState(() {
          _leftKeyboardButton = true;
          _rightKeyboardButton = false;
          _toolsVisible = false;
          // _emojiVisible = false;
          unfocus();
        }));
  }

  void onTapLeftKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _leftKeyboardButton = false;
      _toolsVisible = false;
      // _emojiVisible = false;
      focus();
    });
  }

  void onTapRightKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = false;
      _toolsVisible = false;
      // _emojiVisible = false;
      focus();
    });
  }

  void onTapEmoji() {
    if (!widget.enabled) return;
    setState(() {
      _rightKeyboardButton = true;
      _leftKeyboardButton = false;
      // _emojiVisible = true;
      _toolsVisible = false;
      unfocus();
    });
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());
}

class _QuoteView extends StatelessWidget {
  const _QuoteView({
    Key? key,
    this.onClearQuote,
    required this.content,
  }) : super(key: key);
  final Function()? onClearQuote;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 56.w, right: 100.w),
      color: Styles.c_0C8CE9,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClearQuote,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Styles.ts_333333_14_medium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ImageRes.delQuote.toImage
                ..width = 14.w
                ..height = 14.h,
            ],
          ),
        ),
      ),
    );
  }
}
