

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../presentation/widget/rf_alert_dialog.dart';
import '../presentation/widget/rf_progress_dialog.dart';

class AppUtils {

  //region Navigation or Routing
  navigateTo(BuildContext context, dynamic page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  //endregion

  //region Navigation or Routing
  navigateBack(BuildContext context,) {
    return Navigator.pop(context);
  }
  //endregion

  //region Internet check
  Future<String> checkInternet() async {
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'wifi';
      // Note for Android: When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return 'ignore-ethernet';
    } else if (connectivityResult == ConnectivityResult.vpn ) {
      return 'ignore-vpn';
      // Note for iOS and macOS: There is no separate network interface type for [vpn]. It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return 'ignore-bluetooth';
    } else if (connectivityResult == ConnectivityResult.other) {
      return 'ignore-other';
    } else if (connectivityResult == ConnectivityResult.none) {
      return 'ignore-none';
    } else {
      return 'ignore-error';
    }
  }
  //endregion

  //region App exit dialog
  Future showAppExitDialog({required BuildContext context}) {
    return showAlertDialog(
        context: context,
        cancelable: false,
        title: 'Exit',
        subTitle: 'Do you want to exit from the App?',
        okText: 'YES',
        okPressed: () {
          SystemNavigator.pop();
        },
        cancelText: 'NO',
        cancelPressed: () {
          Navigator.pop(context);
        });
  }
  //endregion

  //region Alert Dialog
  //region Dialog
  Future showAlertDialog({required BuildContext context, required bool cancelable, required String title, required String subTitle, required String okText, required Function okPressed, String? cancelText, Function? cancelPressed}){
    return showDialog(
        context: context,
        barrierDismissible: cancelable ? true : false,
        builder: (BuildContext context) {
          return PopScope(
              canPop: cancelable ? true : false,
              child: RFAlertDialog(
                  title: title,
                  subTitle: subTitle,
                  okText: okText,
                  cancelText: cancelText,
                  cancelPressed: cancelPressed,
                  okPressed: okPressed)
          );
        });
  }
  //endregion

  //region Progress dialog
  Future showProgressDialog({required BuildContext context, String? title, String? subTitle}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
              canPop: false,
              child: RFProgressDialog(
                  title: title,
                  subTitle: subTitle)
          );
        });
  }
  //endregion

  //region Scroll to down
  void scrollDown({required ScrollController scrollController}) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
  //endregion

  //region Scroll to up
  void scrollUp({required ScrollController scrollController}) {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
  //endregion

  //region Toast Message
  toast({required String msg, Color? backgroundColor, Color? textColor, double? textSize, Toast? length, ToastGravity? position, int? durationForIOSandWebSec}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_LONG,
      gravity: position ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: durationForIOSandWebSec ?? 1,
      backgroundColor: backgroundColor ?? Colors.blueAccent,
      textColor: textColor ?? Colors.white,
      fontSize: textSize ?? 16.sp,
    );
  }
  //endregion

  Future delayed({required int millisecond, Function? onDelayed}) async {
    return await Future.delayed(Duration(milliseconds: millisecond), () {if(onDelayed!=null)onDelayed();});
  }

}