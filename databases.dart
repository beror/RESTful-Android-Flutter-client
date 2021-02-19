import 'package:sqflite/sqflite.dart';

Future<Database> db;

Future<String> getTokenFromDB(String name) async { //undefined for >1 entry having the same name
  var _db = await db;
  return await _db
      .query('tokens')
      .then((entries) {
        if(entries.isEmpty) return null;
        else return entries[0]["value"];
  });
}

void insertTokenInDB({int id, String name, String value}) async {
  var _db = await db;
  print("insertTokenToDB. _db:" + _db.toString() + "\nid: " + id.toString() + "\nname: " + name + "\nvalue: " + value);

  _db.rawInsert("INSERT OR REPLACE INTO tokens VALUES(?, ?, ?)", [id, name, value]);
}