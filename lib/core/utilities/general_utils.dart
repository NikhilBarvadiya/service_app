// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches, deprecated_member_use, void_checks

import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_app/controller/app_controller.dart';
import 'package:url_launcher/url_launcher.dart';

var loadingCtrl = Get.find<AppController>();

List dialCodes = [
  {
    "alpha2Code": "US",
    "dial_code": "+1",
  },
  {
    "alpha2Code": "IN",
    "dial_code": "+91",
  },
  {
    "alpha2Code": "DE",
    "dial_code": "+49",
  }
];

Future<dynamic> splitDialCodeFromPhone(alpha2Code, String phone) async {
  dynamic data;

  for (var code in dialCodes) {
    if (code['alpha2Code'] == alpha2Code) {
      data = {
        'phone': phone.replaceAll(code['dial_code'], ''),
        'dial_code': code['dial_code'],
      };
      return;
    }
  }
  return data;
}

String trans(String val) {
  if (val.isNotEmpty) {
    return val.tr;
  }
  return val;
}

String getUniqueId() {
  String id = DateTime.now().day.toString() + DateTime.now().month.toString() + DateTime.now().year.toString() + DateTime.now().hour.toString() + DateTime.now().minute.toString() + DateTime.now().second.toString() + DateTime.now().microsecond.toString();
  return id;
}

printLog(val) {
  log(val);
}

jsonGet(json, String path, defaultValue) {
  try {
    List pathSplitter = path.split(".");

    /// <String,dynamic> || String
    var returnValue;

    json.forEach(
      (key, value) {
        var currentPatten = pathSplitter[0];
        int index = 0;

        if (currentPatten.contains('[') && currentPatten.contains(']')) {
          int index1 = currentPatten.indexOf('[');
          int index2 = currentPatten.indexOf(']');

          index = int.parse(currentPatten.substring(index1 + 1, index2));
          currentPatten = currentPatten.substring(0, index1);
        }

        if (key == currentPatten) {
          if (pathSplitter.length == 1) {
            returnValue = value;
            return;
          }

          pathSplitter.remove(pathSplitter[0]);

          if (value == null) {
            returnValue = defaultValue;
            return;
          }
          try {
            try {
              value = value.toJson();
            } catch (error) {}

            try {
              if (value is List) {
                value = value[index];
              }
            } catch (error) {}

            returnValue = jsonGet(value, pathSplitter.join("."), defaultValue);
          } catch (error) {
            returnValue = defaultValue;
          }
          return;
        }
      },
    );

    return returnValue ?? defaultValue;
  } on Exception {
    return defaultValue;
  }
}

launchURL(String url) async {
  await canLaunch(url) ? await launch(url) : Get.snackbar('error', 'Could not launch $url');
}

void showLoading() {
  return loadingCtrl.showLoading();
}

void hideLoading() {
  return loadingCtrl.hideLoading();
}

List arrayFilter(List val) {
  if (val.isNotEmpty) {
    List newArray = [];
    for (int i = 0; i < val.length; i++) {
      if (val[i] != null) {
        newArray.add(val[i]);
      }
    }
    return newArray;
  } else {
    return [];
  }
}
