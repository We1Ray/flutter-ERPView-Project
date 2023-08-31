import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../api/callApi.dart';
import '../main.dart';
import '../model/account_model.dart';
import '../provider/loginProvider.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> checkNetwork() async {
      var netWorkCheck = false;
      try {
        var callHello = await getApi(back_ip + '/public/hello', 'DS');
        if (callHello != Null) {
          netWorkCheck = true;
        } else {
          showNetworkAlertDialog(context, '');
        }
      } catch (e) {
        showNetworkAlertDialog(context, e);
      }
      return netWorkCheck;
    }

    Future<void> requestMobilePermission() async {
      var grant = await Permission.storage.isGranted &&
          await Permission.camera.isGranted;

      if (!grant) {
        Map<Permission, PermissionStatus> result = await [
          Permission.storage,
          Permission.camera,
        ].request();

        if (result[Permission.storage]!.isPermanentlyDenied ||
            result[Permission.camera]!.isPermanentlyDenied) {
          if (!(await Permission.storage.isGranted &&
              await Permission.camera.isGranted)) {
            showPermissionAlertDialog(context);
          }
        } else {
          requestMobilePermission();
        }
      }
    }

    requestMobilePermission();
    checkNetwork();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\n\t\t\tDeanShoes',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          EmailTextBox(),
                          SizedBox(
                            height: 30,
                          ),
                          PasswordTextBox(),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              LoginButton()
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPermissionAlertDialog(BuildContext context) {
    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        openAppSettings().whenComplete(() async => {SystemNavigator.pop()});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text(
          "This app needs access to your Permissions in order to start the app."),
      actions: [
        remindButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class EmailTextBox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onChanged: (value) {
          ref.read(loginProvider.notifier).setAccount(AccountModel.fromJson({
                "account_uid": '',
                "name": '',
                "account": '',
                "email": value,
                "password": ref.read(loginProvider).account == null
                    ? ''
                    : ref.read(loginProvider).account!.password,
                "token": '',
              }));
        });
  }
}

class PasswordTextBox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      style: TextStyle(),
      obscureText: true,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      onChanged: (value) {
        ref.read(loginProvider.notifier).setAccount(AccountModel.fromJson({
              "account_uid": '',
              "name": '',
              "account": '',
              "email": ref.read(loginProvider).account == null
                  ? ''
                  : ref.read(loginProvider).account!.email,
              "password": value,
              "token": '',
            }));
      },
    );
  }
}

void showNetworkAlertDialog(BuildContext context, Object e) {
  // set up the buttons
  Widget remindButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      // OpenSettings.openWIFISetting()
      //     .whenComplete(() async => {SystemNavigator.pop()});
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("This app needs your network turned on to start this app.\n" +
        e.toString()),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class LoginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loginInfo = ref.watch(loginProvider);
    void login() async {
      try {
        var loginAccount = await postApi(back_ip + '/public/login', 'DS', {
          'email': loginInfo.account!.email,
          'password': loginInfo.account!.password
        });
        if (loginAccount['rows'][0] != Null) {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
          String now = dateFormat.format(DateTime.now());

          var newToken = 'M-' +
              base64Url
                  .encode(utf8.encode(loginInfo.account!.account + ';' + now));
          var accessToken = await postApi(
              back_ip + '/public/create_account_access_token', 'DS', {
            'ldap_id': loginAccount['rows'][0]['account'],
            'access_token': newToken,
            'system_uid': 'SYS_00001',
            'isMobile': 'Y'
          });
          if (accessToken != Null) {
            await storage.write(key: 'token', value: newToken);
            await storage.write(
                key: 'acount', value: loginAccount['rows'][0]['account']);
            await storage.write(
                key: 'email', value: loginAccount['rows'][0]['email']);
            await storage.write(
                key: 'uid', value: loginAccount['rows'][0]['account_uid']);
            ref.read(loginProvider.notifier).setAccount(AccountModel.fromJson({
                  "account_uid": loginAccount['rows'][0]['account_uid'],
                  "name": loginAccount['rows'][0]['name'],
                  "account": loginAccount['rows'][0]['account'],
                  "email": loginAccount['rows'][0]['email'],
                  "password": loginAccount['rows'][0]['password'],
                  "token": newToken,
                }));
            Navigator.pushNamed(context, 'webview');
          } else {
            ref.read(loginProvider.notifier).setAccount(AccountModel.fromJson({
                  "account_uid": '',
                  "name": '',
                  "account": '',
                  "email": ref.read(loginProvider).account!.email,
                  "password": ref.read(loginProvider).account!.password,
                  "token": '',
                }));
          }
        } else {
          showNetworkAlertDialog(context, '');
        }
      } catch (e) {
        print(e);
      }
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xff4c505b),
      child: IconButton(
          color: Colors.white,
          onPressed: () {
            login();
          },
          icon: Icon(
            Icons.arrow_forward,
          )),
    );
  }
}
