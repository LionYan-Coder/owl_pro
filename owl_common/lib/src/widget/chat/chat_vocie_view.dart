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

class _ChatVoiceViewState extends State<ChatVoiceView> with AutomaticKeepAliveClientMixin{
  Message get _message => widget.message;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<double> extractionProgressSubscription;

  ValueNotifier<bool> loading = ValueNotifier(true);

  @override
  bool get wantKeepAlive => true; // 保持状态

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


  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white38,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  Future<void> _initializeAudio() async {
    try {

      final soundPath = _message.soundElem?.soundPath ?? '';
      final soundUrl = _message.soundElem?.sourceUrl ?? '';


      if (soundPath.isEmpty && soundUrl.isEmpty){
        Logger.print("audio is empty ${_message.sendID}");
        return;
      }
      var _audioFilePath = soundPath;
      await HttpUtil.download(soundUrl, cachePath: _audioFilePath);

      // 准备播放器并提取波形数据
      if (_audioFilePath.isNotEmpty) {
        await controller.preparePlayer(
          path: _audioFilePath,
          shouldExtractWaveform: true,
          noOfSamples: 100, // 根据需要设置采样数量
        );
      }
    } catch (e) {
      Logger.print(e.toString());
    }
  }

  @override
  void dispose() {
    extractionProgressSubscription.cancel();
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (BuildContext context, bool value, Widget? child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: value ?  Center(
            child: SizedBox(
              width: 10.w,
              height: 10.w,
              child: const CircularProgressIndicator.adaptive(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )  : Row(
            textDirection: widget.isISend == true ?  TextDirection.ltr : TextDirection.rtl,
            children: [
              GestureDetector(
                onTap: () async {
                  controller.playerState.isPlaying
                      ? await controller.pausePlayer()
                      : await controller.startPlayer();
                },
                child: Icon(
                  color: Colors.white,
                  size: 16.w,
                  controller.playerState.isPlaying
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
              ),
              AudioFileWaveforms(
                size: Size(48 + (_message.soundElem?.duration?.toDouble() ?? 0) , 24),
                playerController: controller,
                waveformType:WaveformType.fitWidth,
                playerWaveStyle: playerWaveStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
