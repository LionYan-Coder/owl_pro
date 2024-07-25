import 'dart:developer';

/// print full log
class Logger {
  // Sample of abstract logging function
  static void print(String text) {
    log('** $text', name: 'owl_im_sdk');
  }
}
