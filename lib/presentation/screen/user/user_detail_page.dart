

import 'package:codebase/presentation/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_utils.dart';
import '../../../data/model/user.dart';
import '../../widget/rf_app_bar.dart';
import '../../widget/rf_box_decoration.dart';
import '../../widget/rf_rich_text.dart';

class UserDetailPage extends StatelessWidget {

  UserDetailPage({super.key, required this.user});
  final User user;
  final _appUtils = AppUtils();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, Object? result) async {
        if (didPop) {
          return;
        }
        _appUtils.navigateBack(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: RFAppBar(
          titleText: 'User Details',
          titleSize: 18.sp,
          onPressed: () {
            _appUtils.navigateBack(context);
          },
        ).build(),
        body: Container(
          color: Colors.white54 ,//Color(0xFFF1F1F1),
          child: mainBody(context: context),
        ),
      ),
    );
  }

  //region main body
  Widget mainBody({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Container(
        decoration: RFBoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.fromBorderSide(BorderSide(color: Colors.indigo.withOpacity(0.3), width: 0.5.w))
        ).build(),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 32.h,),
                AvatarWidget(urlString: user.avatar ?? "", defaultString: user.firstName!, size: 160.0, border: 0.5,),
                SizedBox(height: 16.h,),
                RFRichText(text: "${user.firstName.toString()} ${user.lastName ?? ''}", overflow: TextOverflow.ellipsis, color: Colors.black87.withOpacity(0.8), size: 22.sp, weight: FontWeight.bold,),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, size: 18.h, color: Colors.blueAccent.withOpacity(0.8),),
                    SizedBox(width: 8.w),
                    RFRichText(text: "Email : ${user.email!}", overflow: TextOverflow.ellipsis, size: 16.sp, color: Colors.black87, weight: FontWeight.normal,),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call_outlined, size: 18.h, color: Colors.blueAccent.withOpacity(0.8),),
                    SizedBox(width: 8.w),
                    RFRichText(text: "Phone : Not Found!", overflow: TextOverflow.ellipsis, size: 16.sp, color: Colors.black87, weight: FontWeight.normal,),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            )
          ],
        ),
      ),
    );
  }
//endregion
}
