import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main.dart';
import '../model/account_model.dart';
import '../provider/loginProvider.dart';
// #enddocregion platform_imports

class WebViewExample extends ConsumerStatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends ConsumerState<WebViewExample> {
  Future<WebViewController>? _controllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerFuture = getToken(ref);
  }

  Future<WebViewController> getToken(WidgetRef ref) async {
    String? token = await storage.read(key: 'token');
    WebViewController controller = new WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        "account",
        onMessageReceived: (JavaScriptMessage message) async {
          // Handle message received from JavaScript
          var eventData = message.message;
          // Process the received data accordingly
          if (eventData == 'logout') {
            ref.read(loginProvider.notifier).setAccount(AccountModel.fromJson({
                  "account_uid": '',
                  "name": '',
                  "account": '',
                  "email": '',
                  "password": '',
                  "token": '',
                }));
            await storage.write(key: 'token', value: '');
            await storage.write(key: 'acount', value: '');
            await storage.write(key: 'email', value: '');
            await storage.write(key: 'uid', value: '');
            Navigator.pushNamed(context, 'login');
          }
        },
      )
      ..addJavaScriptChannel(
        "file",
        onMessageReceived: (JavaScriptMessage message) async {
          // Handle message received from JavaScript
          var eventData = message.message;
          // Process the received data accordingly
          if (eventData == 'logout') {}
        },
      )
      ..loadRequest(Uri.parse(front_ip + '/admin/system?mt=' + token!));
      print(Uri.parse(front_ip + '/admin/system?mt=' + token));
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<WebViewController>(
        future: _controllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Failed to load controller'));
          }

          return Column(
            children: [
              Expanded(child: WebViewWidget(controller: snapshot.data!)),
            ],
          );
        },
      ),
    );
  }
}
