import 'package:flutter/material.dart';
import 'models/notification.dart';
import 'pages/my_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LocalNotificationService.intialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}
