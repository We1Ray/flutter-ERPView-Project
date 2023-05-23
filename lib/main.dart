import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login.dart';
import 'pages/example/register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/erpWebView.dart';

final String front_ip = 'http://172.20.10.14:3000';
final String back_ip = 'http://172.20.10.14:8080';
final storage = new FlutterSecureStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 取得token
  final storage = new FlutterSecureStorage();
  var token = await storage.read(key: 'token');

  runApp(ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(token: token),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyHomePage(),
      'webview': (context) => WebViewExample()
    },
  )));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 在這裡可以對 token 做判斷，然後傳到應用程式的下一個頁面
    // return token != null ? WebViewExample() : MyHomePage();
    return this.token != null ? WebViewExample() : MyHomePage();
  }
}
