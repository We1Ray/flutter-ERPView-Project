import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getApi(String ip, String factory) async {
  var url = Uri.parse(ip);
  var response = await http.get(
    url,
    headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Factory': factory
    },
  );

  var body = response.body;
  if (body.isNotEmpty) {
    return body;
  } else {
    return Null;
  }
}

Future<dynamic> postApi(
    String ip, String factory, Map<String, String>? parameter) async {
  var url = Uri.parse(ip);
  var response = await http.post(url,
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Factory': factory
      },
      body: utf8.encode(jsonEncode(parameter)));

  var body = response.body;
  if (body.isNotEmpty) {
    return jsonDecode(body);
  } else {
    return Null;
  }
}
