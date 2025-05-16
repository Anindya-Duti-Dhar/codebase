
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'constant.dart';

class API {

  //region Core API
  Future<Response> apiCore({required String address, required String method, String? headerValue, var json}) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10), // time to connect
        receiveTimeout: const Duration(seconds: 10), // time to receive data
        sendTimeout: const Duration(seconds: 10), // time to send request
      ),
    );
    if(headerValue == null || headerValue.toString().isEmpty) {
      headerValue = "reqres-free-v1";
    }
    Map<String, String> headers = {
      'Content-Type': Constant.contentType,
      Constant.headerKey: headerValue
    };
    dio.options.headers = headers;
    dio.options.method = method;
    dio.interceptors.add(PrettyDioLogger());
    try {
      return await dio.request(address, data: json);
    } catch (e) {
      rethrow;
    }
  }
  //endregion

  //region Fetch API
  var apiRequestResponse = {
    "Success": false,
    "Message": "",
    "Packet": {}
  };

  //region api call
  Future fetch({required String httpAddress, String? headerValue}) async {
    var message = '';
    try {
      var apiResponse = await apiCore(address: httpAddress, method: 'GET', headerValue: headerValue);
      if (apiResponse.statusCode == 200) {
        Map response = apiResponse.data;
        apiRequestResponse['Success'] = true;
        apiRequestResponse['Message'] = 'Data Fetched Successfully';
        apiRequestResponse['Packet'] = response;
        return json.encode(apiRequestResponse);
      }
      else {
        apiRequestResponse['Success'] = false;
        if (apiResponse.statusCode == 400) {
          message = 'Bad Request';
        } else if (apiResponse.statusCode == 401) {
          message = 'Unauthorized';
        } else if (apiResponse.statusCode == 403) {
          message = 'Forbidden';
        } else if (apiResponse.statusCode == 404) {
          message = 'Not Found';
        } else if (apiResponse.statusCode == 500) {
          message = 'Internal Server Error';
        } else if (apiResponse.statusCode == 504) {
          message = 'Gateway Timeout';
        } else {
          message = 'Unauthorized';
        }
        apiRequestResponse['Message'] = message;
        apiRequestResponse['Packet'] = '';
        return json.encode(apiRequestResponse);
      }
    } on SocketException catch (e) {
      apiRequestResponse['Success'] = false;
      apiRequestResponse['Message'] = 'SocketException : ${e.message}';
      apiRequestResponse['Packet'] = '';
      return json.encode(apiRequestResponse);
    }  on DioException catch (e) {
      apiRequestResponse['Success'] = false;
      apiRequestResponse['Packet'] = '';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        apiRequestResponse['Message'] = 'DioException : Time out';
      } else {
        apiRequestResponse['Message'] = 'DioException : ${e.message}';
      }
      return json.encode(apiRequestResponse);
    } catch (ex) {
      apiRequestResponse['Success'] = false;
      apiRequestResponse['Message'] = 'API request failed : $ex';
      apiRequestResponse['Packet'] = '';
      return json.encode(apiRequestResponse);
    }
  }
  //endregion

  //endregion

}
