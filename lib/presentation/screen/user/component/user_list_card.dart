

import 'package:codebase/data/model/user.dart';
import 'package:codebase/presentation/widget/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widget/rf_box_decoration.dart';
import '../../../widget/rf_rich_text.dart';

class UserListCard extends StatelessWidget {

  const UserListCard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    //region variable
    String name = 'Name not found!';
    if (user.firstName != null) {
      if (user.firstName.toString().trim().isNotEmpty) {
        name = "${user.firstName.toString()} ${user.lastName ?? ''}";
      }
    }
    String email = 'Email not found!';
    if (user.email != null) {
      if (user.email.toString().trim().isNotEmpty) {
        email = user.email.toString();
      }
    }
    //endregion
    return Container(
      decoration: RFBoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.fromBorderSide(BorderSide(color: Colors.indigo.withOpacity(0.3), width: 0.5.w))
      ).build(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 4.h),
              child: AvatarWidget(urlString: user.avatar ?? "", defaultString: name),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: RFRichText(text: name, overflow: TextOverflow.ellipsis, color: Colors.black87, size: 16.sp, weight: FontWeight.bold,),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.email_outlined, size: 17.h, color: Colors.blueAccent.withOpacity(0.8),),
                            SizedBox(width: 4.w),
                            Expanded(child: RFRichText(text: email, overflow: TextOverflow.ellipsis, size: 14.sp, color: Colors.black87, weight: FontWeight.normal,)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
