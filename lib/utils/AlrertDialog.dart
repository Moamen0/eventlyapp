import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:flutter/material.dart';

class AlretDiallogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Row(
          children: [
            CircularProgressIndicator(
              color: AppColor.primaryLightColor,
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              message,
              style: AppStyle.medium16Black,
            )
          ],
        ));
      },
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void showMessage(
      {required BuildContext context,
      required String message,
      String? title,
      String? positiveButtonText,
      String? negativeButtonText,
      Function? onPositivePressed,
      Function? onNegativePressed}) {
    List<Widget>? actions = [];
    if (negativeButtonText != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            onNegativePressed?.call();
          },
          child: Text(
            negativeButtonText,
            style: AppStyle.medium20Primary,
          )));
    }
    if (positiveButtonText != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPositivePressed?.call();
          },
          child: Text(
            positiveButtonText,
            style: AppStyle.medium20Primary,
          )));
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              title ?? "",
              style: AppStyle.medium16Black,
            ),
            content: Text(
              message,
              style: AppStyle.medium16Black,
            ),
            actions: actions);
      },
    );
  }
}
