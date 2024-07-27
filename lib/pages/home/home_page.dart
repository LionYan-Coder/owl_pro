import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("home"),
    );
  }
}
