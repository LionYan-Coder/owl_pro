import 'package:flutter_test/flutter_test.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owl_im_sdk/owl_im_sdk_platform_interface.dart';
import 'package:owl_im_sdk/owl_im_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOwlImSdkPlatform
    with MockPlatformInterfaceMixin
    implements OwlImSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OwlImSdkPlatform initialPlatform = OwlImSdkPlatform.instance;

  test('$MethodChannelOwlImSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOwlImSdk>());
  });

  test('getPlatformVersion', () async {
    OwlImSdk owlImSdkPlugin = OwlImSdk();
    MockOwlImSdkPlatform fakePlatform = MockOwlImSdkPlatform();
    OwlImSdkPlatform.instance = fakePlatform;

    expect(await owlImSdkPlugin.getPlatformVersion(), '42');
  });
}
