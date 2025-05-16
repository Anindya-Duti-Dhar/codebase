

import 'package:codebase/core/app_utils.dart';
import 'package:codebase/logic/user/list/user_list_cubit.dart';
import 'package:codebase/presentation/screen/user/component/user_list_card.dart';
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
          BlocProvider(create: (BuildContext context) => UserListCubit()..loadData()),
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

  //region main list
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
                      hintText: 'SEARCH USER NAME',
                      prefixIcon: Icon(Icons.person_outline_outlined, size: 20.h, color: Colors.blue,),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.blue.withOpacity(0.8),
                          size: 26.h,
                        ),
                        onPressed: () async {

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
                      },
                    ),
                  )
              ),
            ],
          ),
        ),

        Expanded(
          child: state.data.data!.isNotEmpty
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
                  }
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  searchController.clear();
                  cubit.loadData(context: context);
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (item, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: GestureDetector(
                          onTap: () {

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
