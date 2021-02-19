import 'dart:convert';
import 'package:flutter_and_server/databases.dart';
import 'package:http/http.dart';

String address = "http://192.168.0.103:8085/";
String receivedJWT;

Future<int> signup(String username, String password) async {
  String postBody = jsonEncode({"username": username, "password": password});
  var response = await post(address + "signup", body: postBody);

  return response.statusCode;
}

Future<int> login(String username, String password) async {
  String postBody = jsonEncode({"username": username, "password": password});

  var response = await post(address + "login", body: postBody);
  print("Received status code: ${response.statusCode}");

  if(receivedJWT != null) {
    print("receivedJWT is not null. It's a " + receivedJWT.runtimeType.toString());
    insertTokenInDB(id: 0, name: "jwt", value: receivedJWT);
    return response.statusCode;
  }

  receivedJWT = response.headers["authorization"]
      .split(" ")
      .elementAt(1);
  print("Received JWT: " + receivedJWT);

  insertTokenInDB(id: 0, name: "jwt", value: receivedJWT);

  return response.statusCode;
}

Future<Response> getPLangs() async {
  return await get(address + "PLanguages", headers: {"Authorization": "Bearer " + receivedJWT});
}

Future<int> postPLang(String name) async {
  String postBody = jsonEncode({"name": name});
  var response = await post(address + "PLanguages", body: postBody, headers: {"Authorization": "Bearer " + receivedJWT});
  print("Received status code: ${response.statusCode}");

  return response.statusCode;
}

Future<int> putPLang(String nameToEdit, String newName) async {
  String putBody = jsonEncode({"nameToEdit": nameToEdit, "newName": newName});
  var response = await put(address + "PLanguages", body: putBody, headers: {"Authorization": "Bearer " + receivedJWT});
  print("Received status code: ${response.statusCode}");

  return response.statusCode;
}

Future<int> deletePLang(int pLangID) async {
  var response = await delete(address + "PLanguages/" + pLangID.toString(), headers: {"Authorization": "Bearer " + receivedJWT});
  print("Received status code: ${response.statusCode}");

  return response.statusCode;
}