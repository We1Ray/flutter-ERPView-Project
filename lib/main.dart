import 'package:flutter/material.dart';
import 'package:loginuicolors/login.dart';
import 'package:loginuicolors/register.dart';
import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MyLogin(),
//     routes: {
//       'register': (context) => MyRegister(),
//       'login': (context) => MyLogin(),
//     },
//   ));
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _permission = false;

  void _getPermission() async {
    var grant = await Permission.camera.request().isGranted;
    setState(() {
      _permission = grant;
    });
  }

  @override
  void initState() {
    while (!_permission) {
      _getPermission();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLogin(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
      },
    );
  }
}
