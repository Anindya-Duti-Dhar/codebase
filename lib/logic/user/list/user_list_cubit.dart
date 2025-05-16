
import 'package:codebase/core/app_utils.dart';
import 'package:codebase/data/model/user_response.dart';
import 'package:codebase/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {

  UserListCubit() : super(UserListLoadingState());

  final _repository = UserRepository();
  final _appUtils = AppUtils();

  loadData({BuildContext? context, int? pageNo}) async {
    if(context != null){
      _appUtils.showProgressDialog(context: context);
    }
    await _repository.userListFetch(
      pageNo: pageNo,
      onComplete: (isSuccess, message, data) {
        if(context != null){
          Navigator.pop(context);
        }
        emit(UserListLoadedState(success: isSuccess, message: message, data: data));
      },);
  }

}
