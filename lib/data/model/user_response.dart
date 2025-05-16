import 'dart:convert';

import 'package:codebase/data/model/user.dart';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<User>? data;

  UserResponse({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    page: json["page"],
    perPage: json["per_page"],
    total: json["total"],
    totalPages: json["total_pages"],
    data: json["data"] == null ? [] : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "total": total,
    "total_pages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
