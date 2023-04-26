import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;
//"mongodb+srv://Vaco:VacoSoftlond1.@vacocluster.e9dpp.mongodb.net/test?authSource=admin&replicaSet=atlas-ec3r4y-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true"
  
void main() async {
  var db = await Db.create(
      "mongodb+srv://Vaco:Softlond2022.@vacocluster.e9dpp.mongodb.net/Vaco_db?authSource=admin&replicaSet=atlas-ec3r4y-shard-0&readPreference=primary&appname=MongoDB%20Compass&ssl=true");
  var authors = <String, Map>{};
  var users = <String, Map>{};
  await db.open();
  print('====================================================================');
  print('>> Adding Authors');
  var collection = db.collection('usuariosLogin');
  await collection.insertMany([
    {
      'name': 'William Shakespeare',
      'email': 'william@shakespeare.com',
      'age': 587
    },
    {'name': 'Jorge Luis Borges', 'email': 'jorge@borges.com', 'age': 123}
  ]);
  await db.ensureIndex('usuariosLogin',
      name: 'meta', keys: {'_id': 1, 'name': 1, 'age': 1});
  await collection.find().forEach((v) {
    print(v);
    authors[v['name'].toString()] = v;
  });
  print('====================================================================');
  print('>> Authors ordered by age ascending');
  await collection.find(where.sortBy('age')).forEach(
      (auth) => print("[${auth['name']}]:[${auth['email']}]:[${auth['age']}]"));
  print('====================================================================');
  await db.close();
}
