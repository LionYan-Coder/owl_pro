import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:owl_common/owl_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';

class QRcode extends StatefulWidget {
  const QRcode({
    super.key,
    required this.code,
    this.onSave,
  });

  final Function(Future<void> Function())? onSave;
  final String code;

  @override
  State<QRcode> createState() => QRcodeState();
}

class QRcodeState extends State<QRcode> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    if (widget.onSave != null) {
      widget.onSave!(_saveQrCodeToGallery);
    }
  }

  Future<void> _saveQrCodeToGallery() async {
    if (await Permission.storage.request().isGranted) {
      screenshotController.capture().then((Uint8List? image) async {
        if (image != null) {
          await ImageGallerySaver.saveImage(image);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('QR code saved to gallery')),
            );
          }
        }
      }).catchError((error) {
        Logger.print("QRcode _saveQrCodeToGallery error = ${error.toString()}");
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        width: 200.w,
        height: 200.w,
        padding: EdgeInsets.all(8.w),
        child: PrettyQrView.data(
            data: widget.code,
            decoration: PrettyQrDecoration(
                shape: const PrettyQrSmoothSymbol(
                  color: Color(0xFF1975E5),
                ),
                image: PrettyQrDecorationImage(
                  image: AssetImage("logo".png, package: 'owl_common'),
                ))),
      ),
    );
  }
}
