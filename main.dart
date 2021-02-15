import 'package:flutter/material.dart';
import 'package:flutter_and_server/requests.dart';

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
                    color: Colors.lightBlue,
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

                        int loginStatusCode = await login(username, password);

                        if(loginStatusCode >= 200 && loginStatusCode <= 300) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Text("Problem has occurred", textAlign: TextAlign.center,)
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

                        int responseCode = await signup(username, password);

                        if(responseCode >= 200 && responseCode <= 300) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Text("Successfully signed up", textAlign: TextAlign.center)));
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Text("Problem has occurred", textAlign: TextAlign.center)
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
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: getPLangs(),
    builder: (context, snapshot) {
      if(snapshot.hasData) {
        if(snapshot.data.statusCode < 200 || snapshot.data.statusCode >= 400)
          return Text("ERROR");

        return Scaffold(
            appBar: AppBar(
                title: Text("My entries")
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
                                return Text("${snapshot.data.jsonDecodedBody[i].keys.elementAt(j)}: ${snapshot.data.jsonDecodedBody[i].values.elementAt(j)}", style: TextStyle(fontSize: 20));
                              },
                              itemCount: snapshot.data.jsonDecodedBody[0].keys.length,
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
              itemCount: snapshot.data.jsonDecodedBody.length
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
                      int responseCode = await postPLang(value);

                      if(responseCode < 200 || responseCode >= 300) {
                        switch (responseCode) {
                          case 401: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Unauthorized", textAlign: TextAlign.center))); break;
                          default: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Error", textAlign: TextAlign.center))); break;
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

                        int responseCode = await putPLang(nameToEdit, newName);

                        if(responseCode < 200 || responseCode >= 300) {
                          switch (responseCode) {
                            case 401: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Unauthorized", textAlign: TextAlign.center))); break;
                            default: Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Error", textAlign: TextAlign.center))); break;
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
                    int responseCode;
                    int idToDelete = int.tryParse("22a");
                    if(idToDelete != null) responseCode = await deletePLang(idToDelete);
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Text("Invalid ID format", textAlign: TextAlign.center)));
                      return;
                    }

                    if (responseCode < 200 || responseCode >= 300) {
                      switch (responseCode) {
                        case 401:
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => Text("Unauthorized", textAlign: TextAlign.center)));
                          break;
                        default:
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => Text("Error", textAlign: TextAlign.center)));
                          break;
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