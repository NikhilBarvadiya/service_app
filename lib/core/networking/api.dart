import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:service_app/common/config.dart';
import 'package:service_app/core/model/api_data_class.dart';
import 'package:service_app/core/utilities/index.dart';
import 'package:service_app/env.dart';

Dio dio = Dio();

bool isApiLoading = false;

class Apis {
  //this is compulsory. do not delete
  Apis() {
    //options
    dio.options
      ..baseUrl = environment['serverConfig']['apiUrl']
      ..validateStatus = (int? status) {
        return status! > 0; //this will always redirect to onResponse method
      }
      ..headers = {
        'Accept': 'application/json',
        'content-type': 'application/json',
      };
    //interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        printLog("interceptors onRequest : ${options.uri}");
        printLog("interceptors onRequest header : ${options.headers}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        printLog("interceptors onResponse : ${response.statusCode}");
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        printLog("interceptors onError : ${e.toString()}");
        return handler.next(e);
      },
    ));
  }

  // ignore: missing_return
  Future<APIDataClass> call(String apiName, body, type) async {
    //default data to class
    APIDataClass apiData = APIDataClass(message: 'No Data', isSuccess: false, data: null);
    try {
      if (kDebugMode) {
        print(body);
      }
      bool isInternet = await isNetworkConnection();
      if (isInternet) {
        dynamic authToken = getStorage(Session.authToken.toString());
        if (kDebugMode) {
          print("authToken==============$authToken");
        }
        if (authToken != null && authToken != '') {
          dio.options.headers["Authorization"] = "Bearer $authToken";
        }
        dynamic response;
        switch (type) {
          case ApiType.get:
            response = await dio.get(apiName, queryParameters: body); //dio request
            break;
          case ApiType.post:
            response = await dio.post(apiName, data: body);
            break;
          case ApiType.delete:
            response = await dio.delete(apiName, data: body);
            break;
          case ApiType.put:
            response = await dio.put(apiName, data: body);
            break;
        }

        apiData = await checkStatus(response, apiName);
      } else {
        goToNoInternetScreen();
      }
      return apiData;
    } on SocketException catch (e) {
      onSocketException(e);
      return apiData;
    } on Exception catch (e) {
      onException(e);
      return apiData;
    }
  }

  //#region functions
  Future<APIDataClass> checkStatus(response, apiName) async {
    log("::: response $apiName: ${response.toString()}");
    printLog("::: statusCode $apiName: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIDataClass(
        isSuccess: response.data['IsSuccess'],
        message: response.data['Message'],
        data: response.data['Data'],
      );
    } else if (response.statusCode == 422 || response.statusCode == 404) {
      return APIDataClass(
        isSuccess: response.data['IsSuccess'],
        message: response.data['Message'],
        data: response.data['Data'],
      );
    } else if (response.statusCode == 401) {
      snackBar('unauthorized access please login');
      removeSpecificKeyStorage(Session.authToken.toString());
      // Get.offAllNamed(AppRoutes.login);
      return APIDataClass(
        isSuccess: response.data['IsSuccess'],
        message: response.data['Message'],
        data: response.data['Data'],
      );
    } else {
      return APIDataClass(
        isSuccess: false,
        message: response.statusMessage,
        data: 0,
      );
    }
  }

  onSocketException(e) {
    printLog("API : SocketException - ${e.toString()}"); //do not delete
    snackBar("noInternet");
  }

  onException(e) {
    printLog("API : Exception - ${e.toString()}"); //do not delete
    snackBar("wentWrong");
  }
}
