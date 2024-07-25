import 'package:flutter/material.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    OwlIM.iMManager.initSDK(
        platformID: 2,
        apiAddr: '127.0.0.1:10002',
        wsAddr: '127.0.0.1:10001',
        dataDir: '/',
        listener: OnConnectListener(onConnecting: () {
          print("onConnecting");
        }, onConnectSuccess: () {
          print("onConnectSuccess");
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            TextButton(onPressed: () {}, child: const Text('login')),
          ],
        ),
      ),
    );
  }
}
