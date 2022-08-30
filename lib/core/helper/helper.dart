import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

final _storage = GetStorage();

class Helper {
  //check internet connectivity
  Future<bool> isNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  //read from storage
  Future<dynamic> read(String name) async {
    dynamic info = await _storage.read(name) ?? '';
    return info != '' ? json.decode(info) : info;
  }

  //write to storage
  Future<dynamic> write(String key, dynamic value) async {
    dynamic object = value != null ? json.encode(value) : value;
    return await _storage.write(key, object);
  }

  //remove a specific key from storage
  removeKey(String key) {
    _storage.remove(key);
  }

  //clean all from storage
  cleanStorage() {
    _storage.erase();
  }

  //raw snack
  toast(String message, Color color) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: color,
      duration: const Duration(milliseconds: 2000),
    );
  }

  //check have nessesary permission
  Future<bool> getPermissionStatus() async {
    bool _locationState = await Permission.location.isGranted;
    bool _cameraState = await Permission.camera.isGranted;
    bool _storageState = await Permission.storage.isGranted;
    bool _microphoneState = await Permission.microphone.isGranted;
    if (_locationState && _cameraState && _storageState && _microphoneState) {
      return true;
    } else {
      return false;
    }
  }

  void successMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.green,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  void errorMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.redAccent,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  void alertMessage(message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Colors.amber,
      borderRadius: 3,
      margin: EdgeInsets.zero,
    );
  }

  void launchURL(String val) async {
    if (await canLaunchUrl(Uri.parse(val))) {
      await launchUrl(Uri.parse(val));
    } else {
      throw 'Could not launch $val';
    }
  }
}
