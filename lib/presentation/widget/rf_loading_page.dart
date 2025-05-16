

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RfLoadingPage extends StatelessWidget {

  const RfLoadingPage({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitCircle(
          color: color ?? Colors.blue,
          size: 72.0.w,
        ),
      ],
    );
  }
}
