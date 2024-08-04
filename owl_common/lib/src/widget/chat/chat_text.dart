import 'package:flutter/material.dart';
import 'package:owl_common/owl_common.dart';

class ChatText extends StatelessWidget {
  const ChatText({
    super.key,
    this.isISend = false,
    required this.text,
    this.allAtMap = const <String, String>{},
    this.prefixSpan,
    this.patterns = const <MatchPattern>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.textStyle,
    this.maxLines,
    this.textScaleFactor = 1.0,
    this.model = TextModel.match,
    this.onVisibleTrulyText,
  });
  final bool isISend;
  final String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double textScaleFactor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final TextModel model;
  final Function(String? text)? onVisibleTrulyText;

  @override
  Widget build(BuildContext context) => MatchTextView(
        text: text,
        textStyle:
            textStyle ?? (isISend ? Styles.ts_FFFFFF_14 : Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14)),
        matchTextStyle: Styles.ts_0C8CE9_14,
        prefixSpan: prefixSpan,
        textAlign: textAlign,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        allAtMap: allAtMap,
        patterns: patterns,
        model: model,
        maxLines: maxLines,
        onVisibleTrulyText: onVisibleTrulyText,
      );
}
