import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

String address = "http://192.168.0.104:8085/PLanguages";
String receivedJWT;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server requests application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignupOrLogin(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests")
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              //GetRoute.getGet();
              Navigator.push(context, MaterialPageRoute(builder: (context) => GetRoute()));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(50)
              ),
              child: Text(
                "Get",
                style: TextStyle(fontSize: 30))
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostFormRoute()));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Text(
                    "Post",
                    style: TextStyle(fontSize: 30))
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PutFormRoute()));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Text(
                    "Put",
                    style: TextStyle(fontSize: 30))
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteFormRoute()));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 30))
            ),
          )
        ],
      ),
    );
  }
}

class SignupOrLogin extends StatelessWidget {
  SignupOrLogin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Welcome")
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              //GetRoute.getGet();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 30))
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30))
            ),
          )
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  createState() => LoginState();
}

class LoginState extends State<Login> {
  final loginFormKey_username = GlobalKey<FormState>();
  final loginFormKey_password = GlobalKey<FormState>();

  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(
            title: Text("Log in")
        ),
        body: Column(
            children: [
              Form(
                  key: loginFormKey_username,
                  child: Padding(
                      child: TextFormField(
                          onSaved: (value) async {
                            username = value;
                          },
                          decoration: InputDecoration(hintText: "Username")
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 20)
                  )
              ),
              Form(
                  key: loginFormKey_password,
                  child: Padding(
                      child: TextFormField(
                        onSaved: (value) async {
                          password = value;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 0)
                  )
              ),
              Padding(
                  child: RaisedButton.icon(
                      icon: Icon(Icons.input, size: 40),
                      label: Text("Log in", style: TextStyle(fontSize: 40)),
                      onPressed: () async {
                        loginFormKey_username.currentState.save();
                        loginFormKey_password.currentState.save();

                        String postBody = "{"
                            "\"username\": \"$username\","
                            "\"password\": \"$password\""
                            "}";
                        print("Body to send: $postBody");
                        var response = await post("http://192.168.0.104:8085/login", body: postBody);
                        print("Received status code: ${response.statusCode}");

                        if(response.statusCode >= 200 && response.statusCode <= 300) {
                          receivedJWT = response.headers["authorization"]
                              .split(" ")
                              .elementAt(1);
                          print("Received JWT: " + receivedJWT);
                          print("Received headers: ${response.headers}");
                          print("Received body: ${response.body}");

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Text("Problem has occurred")
                          ));
                        }
                      },
                      color: Colors.white12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 20)
                  ),
                  padding: EdgeInsets.all(20)
              )
            ]
        )
    );
  }
}

class Signup extends StatefulWidget {
  @override
  createState() => SignupState();
}

class SignupState extends State<Signup> {
  final signupFormKey_username = GlobalKey<FormState>();
  final signupFormKey_password = GlobalKey<FormState>();

  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(
            title: Text("Sign up")
        ),
        body: Column(
            children: [
              Form(
                  key: signupFormKey_username,
                  child: Padding(
                      child: TextFormField(
                          onSaved: (value) async {
                            username = value;
                          },
                          decoration: InputDecoration(hintText: "Username")
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 20)
                  )
              ),
              Form(
                  key: signupFormKey_password,
                  child: Padding(
                      child: TextFormField(
                        onSaved: (value) async {
                          password = value;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 0)
                  )
              ),
              Padding(
                  child: RaisedButton.icon(
                      icon: Icon(Icons.input, size: 40),
                      label: Text("Sign up", style: TextStyle(fontSize: 40)),
                      onPressed: () async {
                        signupFormKey_username.currentState.save();
                        signupFormKey_password.currentState.save();

                        String postBody = "{"
                            "\"username\": \"$username\","
                            "\"password\": \"$password\""
                            "}";
                        print("Body to send: $postBody");
                        var response = await post("http://192.168.0.104:8085/signup", body: postBody);
                        print("Received status code: ${response.statusCode}");

                        if(response.statusCode >= 200 && response.statusCode <= 300) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Text("Successfully signed up")));
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Text("Problem has occurred")
                          ));
                        }
                      },
                      color: Colors.white12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 20)
                  ),
                  padding: EdgeInsets.all(20)
              )
            ]
        )
    );
  }
}

class GetRoute extends StatelessWidget {
  int requestItemCount;
  var jsonDecodedBody;

  Future<Response> getGet() async {
    var response = await get(address, headers: {"Authorization": "Bearer " + receivedJWT});
    print("GET status code: ${response.statusCode}");
    print("GET content length: ${response.contentLength}");
    print("GET headers: ${response.headers}");
    print("GET body: ${response.body}");
    jsonDecodedBody = jsonDecode(response.body);
    requestItemCount = jsonDecodedBody.length;
    return response;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getGet(),
    builder: (context, snapshot) {
      if(snapshot.hasData) {
        if(snapshot.data.statusCode < 200 || snapshot.data.statusCode >= 400)
          return Text("ERROR");

        return Scaffold(
            appBar: AppBar(
                title: Text("Get all entries")
            ),
            body: ListView.builder(
                itemBuilder: (_, i) {
                  return Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: ListView.builder(
                              itemBuilder: (_, j) {
                                return Text("${jsonDecodedBody[i].keys.elementAt(j)}: ${jsonDecodedBody[i].values.elementAt(j)}", style: TextStyle(fontSize: 20));
                              },
                              itemCount: jsonDecodedBody[0].keys.length,
                              shrinkWrap: true
                            ),
                            width: 390,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10)
                              )
                            ),
                          )
                        ]
                      )
                    ],
                  );
                },
              itemCount: jsonDecodedBody.length
            )
        );
      }
      else return Scaffold(appBar: AppBar(title: null), body: Center(child: CircularProgressIndicator()));
    }
  );
}

class PostFormRoute extends StatefulWidget {
  @override
  createState() => PostFormRouteState();
}

class PostFormRouteState extends State<PostFormRoute> {
  final postFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
          title: Text("Post an entry")
        ),
      body: Column(
          children: [
            Form(
              key: postFormKey,
              child: Padding(
                  child: TextFormField(
                    onSaved: (value) async {
                      print(value);
                      String postBody = "{"
                          "\"name\": \"$value\""
                          "}";
                      var response = await post(address, body: postBody,
                          headers: {"Authorization": "Bearer " + receivedJWT});

                      print("Received status code: ${response.statusCode}");

                      if(response.statusCode < 200 || response.statusCode >= 400) {
                        switch (response.statusCode) {
                          case 401: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Unauthorized"))); break;
                          default: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Error"))); break;
                        }
                      }
                    },
                  decoration: InputDecoration(hintText: "Language name")
                ),
                padding: EdgeInsets.fromLTRB(35, 10, 35, 0)
              )
            ),
            Padding(
              child: RaisedButton.icon(
                icon: Icon(Icons.add, size: 50),
                label: Text("Add", style: TextStyle(fontSize: 40)),
                onPressed: () {
                  postFormKey.currentState.save();
                },
                color: Colors.white12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.fromLTRB(25, 20, 25, 20)
              ),
              padding: EdgeInsets.all(20)
            )
          ]
      )
      );
  }
}

class PutFormRoute extends StatefulWidget {
  @override
  createState() => PutFormRouteState();
}

class PutFormRouteState extends State<PutFormRoute> {
  final putFormKeyNameToEdit = GlobalKey<FormState>();
  final putFormKeyNewName = GlobalKey<FormState>();
  var jsonDecodedBody;

  var nameToEdit;
  var newName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(
            title: Text("Put an entry")
        ),
        body: Column(
            children: [
              Form(
                  key: putFormKeyNameToEdit,
                  child: Padding(
                      child: TextFormField(
                          onSaved: (value) async => nameToEdit = value,
                          decoration: InputDecoration(hintText: "Current language name")
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 20)
                  )
              ),
              Form(
                  key: putFormKeyNewName,
                  child: Padding(
                      child: TextFormField(
                        onSaved: (value) async => newName = value,
                        decoration: InputDecoration(hintText: "New language name"),
                      ),
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 0)
                  )
              ),
              Padding(
                  child: RaisedButton.icon(
                      icon: Icon(Icons.edit, size: 40),
                      label: Text("Edit", style: TextStyle(fontSize: 40)),
                      onPressed: () async {
                        putFormKeyNameToEdit.currentState.save();
                        putFormKeyNewName.currentState.save();

                        String putBody = "{"
                            "\"nameToEdit\": \"$nameToEdit\","
                            "\"newName\": \"$newName\""
                            "}";
                        var response = await put(address, body: putBody, headers: {"Authorization": "Bearer " + receivedJWT});

                        print("Received status code: ${response.statusCode}");

                        if(response.statusCode < 200 || response.statusCode >= 400) {
                          switch (response.statusCode) {
                            case 401: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Unauthorized"))); break;
                            default: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Error"))); break;
                          }
                        }
                      },
                      color: Colors.white12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 20)
                  ),
                  padding: EdgeInsets.all(20)
              )
            ]
        )
    );
  }
}

class DeleteFormRoute extends StatefulWidget {
  @override
  createState() => DeleteFormRouteState();
}

class DeleteFormRouteState extends State<DeleteFormRoute> {
  var deleteFormKey = GlobalKey<FormState>();

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete an entry")),
      body: Column(
        children: [
          Form(
            key: deleteFormKey,
            child: Padding(
              child: TextFormField(
                  onSaved: (value) async {
                    var response = await delete(address + "/" + value, headers: {"Authorization": "Bearer " + receivedJWT});

                    print("Received status code: ${response.statusCode}");

                    if(response.statusCode < 200 || response.statusCode >= 400) {
                      switch (response.statusCode) {
                        case 401: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Unauthorized"))); break;
                        default: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Error"))); break;
                      }
                    }
                    },
                  decoration: InputDecoration(hintText: "Language ID to delete")
              ),
                padding: EdgeInsets.fromLTRB(35, 10, 35, 0)
            )
          ),
          Padding(
              child: RaisedButton.icon(
                  icon: Icon(Icons.delete, size: 40),
                  label: Text("Delete", style: TextStyle(fontSize: 40)),
              onPressed: () => deleteFormKey.currentState.save(),
              color: Colors.white12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.fromLTRB(25, 20, 25, 20)
            ),
            padding: EdgeInsets.all(20)
          )
        ]
      )
    );
  }
}