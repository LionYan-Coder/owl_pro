import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:path_provider/path_provider.dart';

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

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<double> extractionProgressSubscription;

  ValueNotifier<bool> loading = ValueNotifier(true);

  @override
  void initState() {
    controller = PlayerController();
    extractionProgressSubscription = controller.onExtractionProgress.listen((progress) {
      loading.value = progress < 1;
    });
    playerStateSubscription = controller.onPlayerStateChanged.listen((d) {
      setState(() {});
    });
    _initializeAudio();
    super.initState();
  }


  Future<void> _initializeAudio() async {
    try {

      final soundPath = _message.soundElem?.soundPath ?? '';
      final soundUrl = _message.soundElem?.sourceUrl ?? '';


      if (soundPath.isEmpty && soundUrl.isEmpty){
        Logger.print("audio is empty ${_message.sendID}");
        return;
      }

      if (widget.isISend){
        await controller.preparePlayer(
          path: soundPath,
          shouldExtractWaveform: true,
          noOfSamples: 100, // 根据需要设置采样数量
        );
        return;
      }
      var path = await IMUtils.createTempFile(
        dir: 'm4a',
        name: '${_message.sendID}.m4a',
      );
     await HttpUtil.download(soundUrl, cachePath: path);
      await controller.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: 100, // 根据需要设置采样数量
      );

    } catch (e) {
      Logger.print(e.toString());
    }
  }

  @override
  void dispose() {
    loading.dispose();
    extractionProgressSubscription.cancel();
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (BuildContext context, bool value, Widget? child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: value ?  Center(
            child: SizedBox(
              width: 10.w,
              height: 10.w,
              child:  CircularProgressIndicator.adaptive(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation<Color>(widget.isISend ? Colors.white : Styles.c_0C8CE9.withOpacity(0.5)),
              ),
            ),
          )  : Row(
            textDirection: widget.isISend == true ?  TextDirection.ltr : TextDirection.rtl,
            children: [
              GestureDetector(
                onTap: () async {
                  controller.playerState.isPlaying
                      ? await controller.pausePlayer()
                      : await controller.startPlayer(
                    finishMode: FinishMode.loop
                  );
                },
                child: Icon(
                  color:widget.isISend ? Colors.white : Styles.c_0C8CE9,
                  size: 16.w,
                  controller.playerState.isPlaying
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
              ),
              AudioFileWaveforms(
                size: Size(48 + (_message.soundElem?.duration?.toDouble() ?? 0) , 28),
                playerController: controller,
                waveformType:WaveformType.fitWidth,
                playerWaveStyle: PlayerWaveStyle(
                  fixedWaveColor: widget.isISend ? Colors.white38 : Styles.c_0C8CE9.withOpacity(0.5) ,
                  liveWaveColor:widget.isISend ? Colors.white : Styles.c_0C8CE9,
                  spacing: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
