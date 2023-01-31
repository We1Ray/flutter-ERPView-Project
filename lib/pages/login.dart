// import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:open_settings/open_settings.dart';
// import 'package:loginuicolors/register.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:package_info/package_info.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:open_file/open_file.dart';
import '../api/callApi.dart';
import '../model/account_model.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool check_Network = false;
  String email = '';
  String password = '';
  String token = '';
  AccountModel? account;

  @override
  void initState() {
    super.initState();
    requestPermission();
    checkNetwork();
    // checkVersion();
  }

  void requestPermission() async {
    var grant =
        await Permission.storage.isGranted && await Permission.camera.isGranted;

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
        requestPermission();
      }
    }
  }

  void checkNetwork() async {
    try {
      var checkNetWork =
          await getApi('http://10.1.200.133:8080/public/hello', 'DS');
      if (checkNetWork != Null) {
        setState(() {
          check_Network = true;
        });
      } else {
        showNetworkAlertDialog(context, '');
      }
    } catch (e) {
      showNetworkAlertDialog(context, e);
      setState(() {
        check_Network = false;
      });
    }
  }

  void login() async {
    try {
      var loginAccount = await postApi('http://10.1.200.133:8080/public/login',
          'DS', {'email': email, 'password': password});

      if (loginAccount != Null) {
        setState(() {
          account = AccountModel.fromJson(loginAccount['rows'][0]);
        });

        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        String now = dateFormat.format(DateTime.now());

        var newToken =
            base64Url.encode(utf8.encode(account!.account_uid + ';' + now));
        var accessToken = await postApi(
            'http://10.1.200.125:8080/public/create_account_access_token',
            'DS', {
          'ldap_id': account!.account,
          'access_token': newToken,
          'system_uid': 'SYS_00001',
        });
        if (accessToken != Null) {
          setState(() {
            token = newToken;
          });
        } else {
          setState(() {
            token = '';
          });
        }
      } else {
        showNetworkAlertDialog(context, '');
      }
    } catch (e) {
      print(e);
    }
  }

  // void checkVersion() async {
  //   if (Platform.isAndroid) {
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     String appName = packageInfo.appName;
  //     String packageName = packageInfo.packageName;
  //     String version = packageInfo.version;
  //     String buildNumber = packageInfo.buildNumber;
  //     Directory tempDir = await getTemporaryDirectory();
  //     String tempPath = tempDir.path;
  //     Directory appDocDir = await getApplicationDocumentsDirectory();
  //     String appDocPath = appDocDir.path;
  //     var directory = await getExternalStorageDirectory();
  //     String storageDirectory = directory!.path;
  //     String _localPath = directory.path;

  //     await FlutterDownloader.enqueue(
  //       // 遠程的APK地址（注意：安卓9.0以上後要求用https）
  //       url: "http://www.ionic.wang/shop.apk",
  //       // 下載保存的路徑
  //       savedDir: _localPath,
  //       // 是否在手機頂部顯示下載進度（僅限安卓）
  //       showNotification: true,
  //       // 是否允許下載完成點擊打開文件（僅限安卓）
  //       openFileFromNotification: true,
  //     );

  //     FlutterDownloader.registerCallback((id, status, progress) {
  //       print(status);
  //       print(progress);
  //     });

  //     OpenFile.open("$_localPath/shop.apk");
  //   }
  // }

  showPermissionAlertDialog(BuildContext context) {
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

  showNetworkAlertDialog(BuildContext context, Object e) {
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
      content: Text(
          "This app needs your network turned on to start this app.\n" +
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

  @override
  Widget build(BuildContext context) {
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
                          TextField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
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
                              setState(() {
                                password = value;
                              });
                            },
                          ),
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
                              CircleAvatar(
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
                              )
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
}
