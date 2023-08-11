import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task/core/utils/palette.dart';

class ViewsToolbox {
  static void showLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 40.w
      ..textColor = Palette.kWhite
      ..radius = 20
      ..backgroundColor = Palette.kBlack
      ..maskColor = Palette.kBlack
      ..indicatorColor = Palette.kWhite
      ..userInteractions = false
      ..dismissOnTap = false
      ..boxShadow = <BoxShadow>[]
      ..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.show(
      status: "جاري التحميل",
    );
  }

  static void dismissLoading() {
    EasyLoading.dismiss();
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.fixed,
        duration: duration,
        content: Center(
          child: Text(
            message,
          ),
        ),
      ),
    );
  }
}
