import 'package:flutter/services.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';

class OwlIM {
  static const version = '1.0.0';

  static const _channel = MethodChannel('owl_im_sdk');

  static final iMManager = IMManager(_channel);

  OwlIM._();
}
