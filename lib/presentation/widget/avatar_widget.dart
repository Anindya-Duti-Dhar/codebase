
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codebase/presentation/widget/rf_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AvatarWidget extends StatelessWidget {

  final String urlString;
  final String defaultString;
  final double? size;
  final double? border;
  const AvatarWidget({super.key, required this.urlString, required this.defaultString, this.size, this.border});

  @override
  Widget build(BuildContext context) {
    if (urlString.isEmpty) {
      return defaultImage();
    }
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border != null ? Border.all(width: border!.w, color: Colors.grey.withOpacity(0.5)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: border != null ? 2 : 1,
              spreadRadius: border != null ? 2 : 1,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: urlString,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 30,
          ),
          placeholder: (context, url) => Container(
            color: Colors.white,
            child: SpinKitFadingCircle(
              color: Colors.grey,
              size: 40.w,
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          width: (size ?? 48).w,
          height: (size ?? 48).h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget defaultImage(){
    return Container(
      width: (size ?? 46).w,
      height: (size ?? 46).h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.withOpacity(0.3),
          border: Border.all(width: 0.5.w, color: Colors.blueAccent),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.6),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]
      ),
      child: Center(
        child: RFText(
            text: defaultString.substring(0, 1),
            size: 24.sp,
            weight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }

}
