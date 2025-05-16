part of 'user_list_cubit.dart';

abstract class UserListState {

  bool success = false;
  String message = '';
  UserResponse data = UserResponse();

  @override
  List<Object> get props => [success, message, data];

}

class UserListLoadingState extends UserListState {}

class UserListLoadedState extends UserListState {

  UserListLoadedState({bool? success, String? message, UserResponse? data}){
    this.success = success ?? this.success;
    this.message = message ?? this.message;
    this.data = data ?? this.data;
  }

}
