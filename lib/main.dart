import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukcytravel/firebase_options.dart';
import 'screens/root.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Travel',
      theme: ThemeData(primaryColor: Colors.teal[900], fontFamily: "Kalam"),
      home: RootApp(),
    );
  }
}
