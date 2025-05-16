
import 'dart:convert';
import 'package:codebase/core/app_utils.dart';
import 'package:codebase/data/model/user_response.dart';
import '../../core/api.dart';
import '../../core/constant.dart';

class UserRepository {

  API api = API();
  final _appUtils = AppUtils();

  //region User List Fetch
  Future userListFetch({int? pageNo, required Function(bool isSuccess, String message, UserResponse data) onComplete}) async {
    UserResponse userResponse = UserResponse();
    await _appUtils.checkInternet().then((value) async {
      if (!value.contains('ignore')) {
        String url = '${Constant.baseUrl}/users';
        if(pageNo != null){
          url = '$url?per_page=${Constant.pageSize}&page=$pageNo';
        }
        var apiResponse = await api.fetch(httpAddress: url);
        var success = jsonDecode(apiResponse)['Success'];
        var message = jsonDecode(apiResponse)['Message'];
        if (success) {
          try {
            var packet = jsonDecode(apiResponse)['Packet'];
            if(packet!=null){
              userResponse = UserResponse.fromJson(packet);
              onComplete(true, 'User fetched successfully', userResponse);
            } else {
              onComplete(false, 'User Fetching Error!\nAPI response is null', userResponse);
            }
          } catch (ex) {
            onComplete(false, 'User Fetching Error!\n${ex.toString()}', userResponse);
          }
        } else {
          onComplete(false, 'User Fetching Error!\n$message', userResponse);
        }
      } else {
        onComplete(false, "Internet Error!\nYou are offline, please check your internet connection.", userResponse);
      }
    });
  }
  //endregion

}