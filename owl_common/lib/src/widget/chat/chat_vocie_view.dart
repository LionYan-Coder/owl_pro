import 'package:flutter/material.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import '../voice/voice_message_package.dart';

class ChatVoiceView extends StatefulWidget {
  final bool isISend;
  final Stream<MsgStreamEv<int>>? sendProgressStream;
  final Message message;

  const ChatVoiceView({
    super.key,
    required this.message,
    required this.isISend,
    this.sendProgressStream,
  });

  @override
  State<ChatVoiceView> createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView> {
  Message get _message => widget.message;

  /// URL address
  String? sourceUrl;

  int? duration;

  @override
  void initState() {
    final sound = _message.soundElem;
    sourceUrl = sound?.sourceUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VoiceMessageView(
        backgroundColor: widget.isISend
            ? Styles.c_0C8CE9
            : Styles.c_F1F1F1.adapterDark(Styles.c_262626),
        controller: VoiceController(
          audioSrc: sourceUrl ?? '',
          onComplete: () {
            /// do something on complete
          },
          onPause: () {
            /// do something on pause
          },
          onPlaying: () {
            /// do something on playing
          },
          onError: (err) {
            /// do somethin on error
          },
          maxDuration: const Duration(seconds: 60),
          isFile: false,
        ),
        isReversed: !widget.isISend,
        circlesColor: Styles.c_0C8CE9,
        activeSliderColor: widget.isISend ? Styles.c_FFFFFF : Styles.c_0C8CE9,
        size: 28,
        circlesTextStyle:
            widget.isISend ? Styles.ts_0C8CE9_10 : Styles.ts_FFFFFF_10,
        counterTextStyle: widget.isISend
            ? Styles.ts_FFFFFF_10
            : Styles.ts_333333_10.adapterDark(Styles.ts_CCCCCC_10));
  }
}
