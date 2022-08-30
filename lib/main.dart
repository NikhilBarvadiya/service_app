import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   ),
  // );

  runApp(
    const MyApp(),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
