import 'dart:html';

import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/models/users.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String,dynamic>?> login(
    String? email,
    String? username,
  ) async {
    try {
      CollectionReference usersCollection = firestore.collection('users');
      QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).where('username', isEqualTo: username).get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length == 0)
         return null;
      Map<String, dynamic>? data = documents[0].data() as Map<String, dynamic>?;

      if (data != null) {
        data['id'] = documents[0].id;
        return data;
      }
      else{
        return null;
      }
    } catch (e) {
      return null;
      throw Exception('$e');
    }
  }

  Future<bool> create(
      String? email,
      String? username,
      String? landline,
      String? mobile,
      ) async {
    try {
      CollectionReference usersCollection = firestore.collection('users');
      DocumentReference newDocumentRef = await usersCollection.add({
        'email' : email,
        'landline' : landline,
        'role' : 1,
        'state' : true,
        'username' : username
      });
      CollectionReference tenantsCollection = firestore.collection('tenants');
      await tenantsCollection.add(Tenant(
        name : username,
        email: email,
        active: false,
        unlimited_folder: false,
        unlimited_group: false,
        address : '',
        phone:'',
        landline: landline,
        folders: [],
        office: '',
        fax : '',
        renewal_date: DateTime(2023,1,1),
        created_date: DateTime.now(),
        logo : '',
        user_id: newDocumentRef.id
        ).toJson()
      );
      return true;
    } catch (e) {
      return false;
      throw Exception('$e');
    }
    return false;
  }

  Future<bool> newUser(
      String? email,
      String? username,
      String? parent_user,
      String? id
      ) async{
    try{
      CollectionReference usersCollection = firestore.collection('users');
      User user = User(
        subuser_id: id,
        email : email,
        username: username,
        parent_user : parent_user
      );
      await usersCollection.add(user.toJson());
      return true;
    }catch(e){
      return false;
    }
  }
  Future<List<User>> getSubUser(String? user_id)async{
    CollectionReference usersCollection = firestore.collection('users');
    QuerySnapshot querySnapshot = await usersCollection.where('parent_user', isEqualTo: user_id).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    List<User> result = [];
    for(QueryDocumentSnapshot snapshot in documents){
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      User user = User();
      user.fromJson(data);
      result.add(user);
    }
    return result;
  }
  Future<bool> saveSubuser(String user_id, List<User> users) async{
    CollectionReference usersCollection = firestore.collection('users');
    QuerySnapshot querySnapshot = await usersCollection.where('parent_user', isEqualTo: user_id).get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    try{
      for(QueryDocumentSnapshot snapshot in documents){
        await usersCollection.doc(snapshot.id).delete();
      }
      for(User user in users){
        await usersCollection.add(user.toJson());
      }
      return true;
    }catch(err){
      return false;
    }
  }
}
