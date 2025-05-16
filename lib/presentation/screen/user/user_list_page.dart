

import 'package:codebase/core/app_utils.dart';
import 'package:codebase/data/model/user_response.dart';
import 'package:codebase/logic/user/list/user_list_cubit.dart';
import 'package:codebase/presentation/screen/user/component/user_list_card.dart';
import 'package:codebase/presentation/screen/user/user_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/rf_app_bar.dart';
import '../../widget/rf_box_decoration.dart';
import '../../widget/rf_loading_page.dart';
import '../../widget/rf_text.dart';
import '../../widget/rf_text_field.dart';

class UserListPage extends StatelessWidget {

  UserListPage({super.key});
  final _appUtils = AppUtils();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => UserListCubit()..loadData(userResponse: UserResponse())),
        ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, Object? result) async {
            if (didPop) {
              return;
            }
            _appUtils.showAppExitDialog(context: context);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: RFAppBar(
              titleText: 'User List',
              titleSize: 18.sp,
              onPressed: () {
                _appUtils.showAppExitDialog(context: context);
              },
            ).build(),
            body: Container(
              color: Color(0xFFF1F1F1),
              child: BlocConsumer<UserListCubit, UserListState>(
                listener: (context, state) async {
                  if (state is UserListLoadedState) {
                    if (!state.success && state.message.isNotEmpty) {
                      _appUtils.toast(msg: state.message);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is UserListLoadedState) {
                    return mainBody(context: context, state: state);
                  } else {
                    return RfLoadingPage(color: Colors.blue);
                  }
                },
              ),
            ),
          ),
        )
    );
  }

  //region main body
  Widget mainBody({required BuildContext context, required UserListLoadedState state}) {
    var cubit = context.read<UserListCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 2.h, left: 16.w, right: 16.w),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8).w,
                    child: RFTextField(
                      decoration: RFBoxDecoration().build(),
                      hintText: 'SEARCH BY FIRST NAME',
                      readOnly: state.data.data != null && state.data.data!.isNotEmpty ? false : true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.blue.withOpacity(0.8),
                          size: 26.h,
                        ),
                        onPressed: () async {
                          cubit.searchData(context: context, searchText: searchController.text, userResponse: state.data);
                        },
                      ),
                      controller: searchController,
                      onChange: (textValue, jsonMapResult) {
                        searchController.text = textValue;
                      },
                    )
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: RFBoxDecoration().build(),
                    child: IconButton(
                      icon: Icon(Icons.filter_list_outlined, color: Colors.blue, size: 26.h),
                      onPressed: () {
                        searchController.clear();
                        _appUtils.toast(msg: 'Filter option is coming soon!');
                      },
                    ),
                  )
              ),
            ],
          ),
        ),

        Expanded(
          child: !state.success && state.message.contains('Internet') && (state.data.data == null || state.data.data!.isEmpty)
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32.h),
                Image.asset('assets/images/warning.png', fit: BoxFit.fitHeight, height: 80.h),
                SizedBox(height: 16.h),
                RFText(text: 'Internet Connection Lost!', weight: FontWeight.w500, size: 18.sp, color: Colors.black87.withOpacity(0.8)),
                SizedBox(height: 24.h),
                GestureDetector(
                    onTap: (){
                      cubit.loadData(context: context, userResponse: state.data);
                    },
                    child: Container(
                        decoration: RFBoxDecoration(
                          color: Colors.blueAccent,
                        ).build(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 32.w),
                          child: RFText(text: 'RETRY', weight: FontWeight.bold, size: 16.sp, color: Colors.white),
                        )
                    )
                ),
                SizedBox(height: 32.h),
              ],
            ),
          )
              : state.data.data != null && state.data.data!.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (isTop) {
                    print('At the top');
                  } else {
                    print('At the bottom');
                    cubit.loadData(context: context, userResponse: state.data);
                  }
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  searchController.clear();
                  cubit.loadData(context: context, userResponse: UserResponse());
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (item, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: GestureDetector(
                          onTap: () {
                            _appUtils.navigateTo(context, UserDetailPage(user: state.data.data![index]));
                          },
                          child: UserListCard(
                            user: state.data.data![index],
                            //onView: (){}
                          )
                      ),
                    );
                  },
                  itemCount: state.data.data!.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
              ),
            ),
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32.h),
                Image.asset('assets/images/empty.png', color: Colors.red, fit: BoxFit.fitHeight, height: 80.h),
                SizedBox(height: 16.h),
                RFText(text: 'No User information found!', weight: FontWeight.w500, size: 18.sp, color: Colors.black87.withOpacity(0.8)),
                SizedBox(height: 24.h),
                GestureDetector(
                    onTap: (){
                      cubit.loadData(context: context, userResponse: state.data);
                    },
                    child: Container(
                        decoration: RFBoxDecoration(
                          color: Colors.blueAccent,
                        ).build(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 32.w),
                          child: RFText(text: 'RETRY', weight: FontWeight.bold, size: 16.sp, color: Colors.white),
                        )
                    )
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
  //endregion
}
