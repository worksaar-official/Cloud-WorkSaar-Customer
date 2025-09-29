import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/view/components/dialog/exit_dialog.dart';

class WillPopWidget extends StatelessWidget {
  final Widget child;
  final String nextRoute;

  const WillPopWidget({super.key, required this.child, this.nextRoute = ''});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          if (nextRoute.isEmpty) {
            showExitDialog(context);
            return Future.value(false);
          } else {
            Get.offAndToNamed(nextRoute);
            return Future.value(false);
          }
        },
        child: child);
  }
}
