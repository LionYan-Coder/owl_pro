import 'dart:async';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_live/src/widgets/live_button.dart';
import 'package:synchronized/synchronized.dart';
import 'package:owl_common/owl_common.dart' as common;

import '../../../live_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:owl_common/owl_common.dart';

class ControlsView extends StatefulWidget {
  const ControlsView({
    super.key,
    this.initState = CallState.call,
    this.callType = CallType.video,
    required this.callStateStream,
    required this.roomDidUpdateStream,
    this.remoteCameraEnabled,
    this.userInfo,
    this.onMinimize,
    this.onCallingDuration,
    this.onEnabledMicrophone,
    this.onEnabledSpeaker,
    this.onCancel,
    this.onHangUp,
    this.onPickUp,
    this.onReject,
    this.onChangedCallState,
  });
  final Stream<Room> roomDidUpdateStream;
  final Stream<CallState> callStateStream;
  final CallState initState;
  final CallType callType;
  final UserInfo? userInfo;
  final bool? remoteCameraEnabled;
  final Function()? onMinimize;
  final Function(int duration)? onCallingDuration;
  final Function(bool enabled)? onEnabledMicrophone;
  final Function(bool enabled)? onEnabledSpeaker;
  final Function()? onPickUp;
  final Function()? onCancel;
  final Function()? onReject;
  final Function(bool isPositive)? onHangUp;
  final Function(CallState state)? onChangedCallState;

  @override
  State<ControlsView> createState() => _ControlsViewState();
}

class _ControlsViewState extends State<ControlsView> {
  late CallState _callState;
  Timer? _callingTimer;
  int _callingDuration = 0;
  String _callingDurationStr = "00:00";

  //
  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription<CallState>? _callStateChangedSub;
  StreamSubscription? _deviceChangeSub;
  StreamSubscription<Room>? _roomDidUpdateSub;

  Room? _room;
  LocalParticipant? _participant;

  /// 默认启用麦克风
  bool _enabledMicrophone = true;

  /// 默认开启扬声器
  bool _enabledSpeaker = true;

  final _lockAudio = Lock();
  final _lockSpeaker = Lock();

  @override
  void dispose() {
    _callStateChangedSub?.cancel();
    _roomDidUpdateSub?.cancel();
    _callingTimer?.cancel();
    _deviceChangeSub?.cancel();
    _participant?.removeListener(_onChange);
    super.dispose();
  }

  @override
  void initState() {
    _onChangedCallState(widget.initState);
    _callStateChangedSub = widget.callStateStream.listen(_onChangedCallState);
    _roomDidUpdateSub = widget.roomDidUpdateStream.listen(_roomDidUpdate);
    // _queryUserInfo();

    _deviceChangeSub =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
    super.initState();
  }

  _roomDidUpdate(Room room) {
    _room ??= room;

    if (room.localParticipant != null && _participant == null) {
      _participant = room.localParticipant;
      _participant?.addListener(_onChange);
    }
  }

  _onChangedCallState(CallState state) {
    if (!mounted) return;
    widget.onChangedCallState?.call(state);
    setState(() {
      _callState = state;
      if (_callState == CallState.calling) {
        _startCallingTimer();
      }
    });
  }

  void _startCallingTimer() {
    _callingTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _callingDurationStr = IMUtils.seconds2HMS(++_callingDuration);
        widget.onCallingDuration?.call(_callingDuration);
      });
    });
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    // setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _toggleAudio() async {
    await _lockAudio.synchronized(() async {
      _enabledMicrophone = !_enabledMicrophone;
      widget.onEnabledMicrophone?.call(_enabledMicrophone);
      if (_enabledMicrophone) {
        await _enableAudio();
      } else {
        await _disableAudio();
      }
    });

    // if (null != _participant) {
    //   if (_participant!.isMicrophoneEnabled()) {
    //     _disableAudio();
    //   } else {
    //     _enableAudio();
    //   }
    // }
  }

  void _toggleSpeaker() async {
    await _lockSpeaker.synchronized(() async {
      _enabledSpeaker = !_enabledSpeaker;
      widget.onEnabledSpeaker?.call(_enabledSpeaker);
      if (_enabledSpeaker) {
        await _enableSpeaker();
      } else {
        await _disableSpeaker();
      }
      setState(() {});
    });
  }

  Future<void> _disableAudio() async {
    await _participant?.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await _participant?.setMicrophoneEnabled(true);
  }

  Future<void> _disableVideo() async {
    await _participant?.setCameraEnabled(false);
  }

  Future<void> _enableVideo() async {
    await _participant?.setCameraEnabled(true,
        cameraCaptureOptions: CameraCaptureOptions(cameraPosition: position));
  }

  Future<void> _disableSpeaker() async {
    await Hardware.instance.setSpeakerphoneOn(false);
  }

  Future<void> _enableSpeaker() async {
    await Hardware.instance.setSpeakerphoneOn(true);
  }

  void _selectAudioOutput(MediaDevice device) async {
    await _room?.setAudioOutputDevice(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await _room?.setAudioInputDevice(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    await _room?.setVideoInputDevice(device);
    setState(() {});
  }

  void _toggleCamera() async {
    //
    final track = _participant?.videoTrackPublications.firstOrNull?.track;
    if (track == null) return;
    Helper.switchCamera(track.mediaStreamTrack);
    // try {
    //   final newPosition = position.switched();
    //   await track.setCameraPosition(newPosition);
    //   // setState(() {
    //   //   position = newPosition;
    //   // });
    // } catch (error, stack) {
    //   Logger.print('could not restart track: $error $stack');
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 16.w,
              top: 7.h,
              child: IconButton(
                  onPressed: widget.onMinimize,
                  icon: "nvbar_ico_shrink_black".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w
                    ..color = _enabledCamera ? Styles.c_CCCCCC :  Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
            ),
            Positioned(
              top: 86.h,
              width: 1.sw,
              child: _owlLogoView,
            ),
            Positioned(
              bottom: 32.h,
              width: 1.sw,
              child: Column(
                children: [
                  Visibility(
                      visible: isBeCalled || isBeRejected,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 24.w, horizontal: 40),
                        margin: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Styles.c_F6F6F6
                                        .adapterDark(Styles.c_161616)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buttonGroup1,
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buttonGroup2,
                  ),
                ],
              ),
            ),
            // Positioned(
            //   bottom: 156.h,
            //   width: 1.sw,
            //   child: Center(child: _videoCallingDurationView),
            // ),
            // if (_callState == CallState.connecting) const LiveLoadingView(),
          ],
        ),
      );

  List<Widget> get _buttonGroup1 {
    if (_callState == CallState.beCalled ||
        _callState == CallState.connecting &&
            widget.initState == CallState.beCalled) {
      return [
        LiveButton.pickUp(onTap: widget.onPickUp),
        LiveButton.reject(onTap: widget.onReject),
      ];
    } else if (_callState == CallState.beRejected ||
        _callState == CallState.connecting &&
            widget.initState == CallState.call) {
      return [
        LiveButton.callAgain(onTap: widget.onCancel),
        LiveButton.giveUp(onTap: widget.onCancel)
      ];
    }
    return [];
  }

  List<Widget> get _buttonGroup2 {

    if (_callState == CallState.call ||
        _callState == CallState.connecting &&
            widget.initState == CallState.call) {
      return [
        LiveButton.speaker(
          on: _enabledSpeaker,
          onTap: _toggleSpeaker,
          enabledCamera: _enabledCamera,
        ),
        LiveButton.video(
            on: _enabledLocalCamera,
            enabledCamera: _enabledCamera,
            onTap: (_enabledCamera ? _disableVideo : _enableVideo)),
        LiveButton.microphone(
          on: _enabledMicrophone,
          onTap: _toggleAudio,
          enabledCamera: _enabledCamera,
        ),
        LiveButton.hungUp(
          onTap: () => widget.onHangUp?.call(true),
          enabledCamera: _enabledCamera,
        ),
      ];
    } else if (_callState == CallState.beCalled ||
        _callState == CallState.connecting &&
            widget.initState == CallState.beCalled) {
      return [
        // LiveButton.reject(onTap: widget.onReject),
        // LiveButton.pickUp(onTap: widget.onPickUp),
        LiveButton.speaker(
          on: _enabledSpeaker,
          onTap: _toggleSpeaker,
          enabledCamera: _enabledCamera,
        ),
        LiveButton.video(
          on: _enabledLocalCamera,
          onTap: (_enabledCamera ? _disableVideo : _enableVideo),
          enabledCamera: _enabledCamera,
        ),
        LiveButton.microphone(
          on: _enabledMicrophone,
          onTap: _toggleAudio,
          enabledCamera: _enabledCamera,
        ),
      ];
    } else if (_callState == CallState.calling) {
      return [
        LiveButton.speaker(
          on: _enabledSpeaker,
          onTap: _toggleSpeaker,
          enabledCamera: _enabledCamera,
        ),
        LiveButton.video(
          on: _enabledLocalCamera,
          onTap: (_enabledCamera ? _disableVideo : _enableVideo),
          enabledCamera: _enabledCamera,
        ),
        LiveButton.microphone(
          on: _enabledMicrophone,
          onTap: _toggleAudio,
          enabledCamera: _enabledCamera,
        ),
        LiveButton.hungUp(
          onTap: () => widget.onHangUp?.call(true),
          enabledCamera: _enabledCamera,
        ),
      ];
    }
    return [];
  }

  bool get _enabledLocalCamera => _participant?.isCameraEnabled() ?? false;

  bool get _enabledCamera => widget.remoteCameraEnabled ?? false;

  bool get isBeCalled =>
      _callState == CallState.beCalled ||
      _callState == CallState.connecting &&
          widget.initState == CallState.beCalled;

  bool get isBeRejected =>
      _callState == CallState.beRejected ||
      _callState == CallState.connecting && widget.initState == CallState.call;

  bool get isVideo => widget.callType == CallType.video;

  bool get isCalling => _callState == CallState.calling;

  Widget get _videoCallingDurationView => Visibility(
        visible: isVideo && isCalling,
        child: _callingDurationStr.toText..style = Styles.ts_FFFFFF_18,
      );

  Widget get _owlLogoView {
    String text;
    String ico;
    if (_callState == CallState.call) {
      text = StrRes.waitingVideoCallHint;
      ico = "videocall_ico_request";
    } else if (_callState == CallState.beCalled) {
      text = StrRes.invitedVideoCallHint;
      ico = "videocall_ico_request";
    } else if (_callState == CallState.connecting) {
      ico = "videocall_ico_request";
      text = StrRes.connecting;
    } else {
      ico = "videocall_ico_connected";
      text = _callingDurationStr;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: !_enabledCamera,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24).h,
            child: AvatarGlow(
              glowRadiusFactor: 0.2,
              glowCount: 3,
              child: ClipOval(
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  color: Colors.white,
                  child: Center(
                    child: "logo".png.toImage
                      ..width = 45.w
                      ..height = 50.w,
                  ),
                ),
              ),
            ),
          ),
        ),
        8.gapv,
        "chat_live_title".tr.toText..style =_enabledCamera ?  common.Styles.ts_FFFFFF_16_medium : common.Styles.ts_333333_20_medium.adapterDark(common.Styles.ts_FFFFFF_20_medium),
        8.gapv,
        Container(
          constraints: BoxConstraints(maxWidth: 120.w),
          height: 24.h,
          decoration: BoxDecoration(
              color: common.Styles.c_0C8CE9.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.r)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ico.svg.toSvg
                  ..width = 14.w
                  ..height = 14.w,
                4.gaph,
                text.tr.toText..style = common.Styles.ts_0C8CE9_12
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get _userInfoView {
    String text;
    if (_callState == CallState.call) {
      text =
          isVideo ? StrRes.waitingVideoCallHint : StrRes.waitingVoiceCallHint;
    } else if (_callState == CallState.beCalled) {
      text =
          isVideo ? StrRes.invitedVideoCallHint : StrRes.invitedVoiceCallHint;
    } else if (_callState == CallState.connecting) {
      text = StrRes.connecting;
    } else {
      text = isVideo ? '' : _callingDurationStr;
    }

    String? nickname = IMUtils.emptyStrToNull(widget.userInfo!.remark) ??
        widget.userInfo!.nickname;
    String? faceURL = widget.userInfo!.faceURL;

    return Visibility(
      visible: !(isVideo && isCalling),
      child: Column(
        children: [
          AvatarView(width: 70.w, height: 70.h, text: nickname, url: faceURL),
          10.verticalSpace,
          (nickname ?? '').toText..style = Styles.ts_FFFFFF_20_medium,
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: text.toText
              ..style = Styles.ts_FFFFFF_18
              ..maxLines = 1
              ..overflow = TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
