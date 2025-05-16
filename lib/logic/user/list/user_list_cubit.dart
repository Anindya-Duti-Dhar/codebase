
import 'package:codebase/core/app_utils.dart';
import 'package:codebase/data/model/user.dart';
import 'package:codebase/data/model/user_response.dart';
import 'package:codebase/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {

  UserListCubit() : super(UserListLoadingState());

  final _repository = UserRepository();
  final _appUtils = AppUtils();

  loadData({BuildContext? context, required UserResponse userResponse}) async {
    int pageNo = 1;
    if(userResponse.page != null){
      if(userResponse.page == userResponse.totalPages){
        return _appUtils.toast(msg: 'No more data!');
      } else {
        pageNo = userResponse.page!+1;
      }
    }
    if(context != null){
      _appUtils.showProgressDialog(context: context);
    }
    await _repository.userListFetch(
      pageNo: pageNo,
      onComplete: (isSuccess, message, data) {
        if(context != null){
          Navigator.pop(context);
        }
        if(userResponse.data != null && userResponse.data!.isNotEmpty){
          List<User> userList = userResponse.data!;
          if(data.data != null && data.data!.isNotEmpty){
            userList.addAll(data.data!);
          }
          data.data = userList;
        }
        emit(UserListLoadedState(success: isSuccess, message: message, data: data));
      },);
  }

  searchData({required BuildContext context, required String searchText, required UserResponse userResponse}){
    _appUtils.showProgressDialog(context: context);
    if(userResponse.data != null && userResponse.data!.isNotEmpty){
      if(searchText.trim().isNotEmpty){
        List<User> userList = userResponse.data!.where((user) => user.firstName == searchText).toList();
        if(userList.isEmpty){
          Navigator.pop(context);
          return _appUtils.toast(msg: 'User not found!', backgroundColor: Colors.red);
        }
        userResponse.data = userList;
      }
    }
    Navigator.pop(context);
    emit(UserListLoadedState(success: true, message: '', data: userResponse));
  }

}
