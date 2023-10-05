import 'dart:html';

import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/models/users.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String,dynamic>?> login(
    String? email,
    String? password,
  ) async {
    try {
      CollectionReference usersCollection = firestore.collection('users');
      QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).where('password', isEqualTo: password).get();
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
  Future<Map<String,dynamic>?> loginByUser(
      String? email,
      String? password,
      ) async {
    try {
      CollectionReference usersCollection = firestore.collection('subusers');
      QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).where('password', isEqualTo: password).get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length == 0)
        return null;
      Map<String, dynamic>? data = documents[0].data() as Map<String, dynamic>?;

      if (data != null) {
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
      String? password,
      String? firstname,
      String? lastname,
      bool hasOffice,
      String? countryID
      ) async {
    try {
      CollectionReference usersCollection = firestore.collection('users');
      DocumentReference newDocumentRef = await usersCollection.add({
        'email' : email,
        'landline' : landline,
        'role' : 1,
        'state' : true,
        'username' : username,
        'password' : password
      });

      CollectionReference assetTypeCollection = firestore.collection('assettypes');
      await assetTypeCollection.add(AssetType(id:generateID(),type:'Default',userid: newDocumentRef.id).toJson());

      CollectionReference categoryCollection = firestore.collection('categories');
      await categoryCollection.add(Category(id:generateID(),name:'Default',userid: newDocumentRef.id).toJson());

      CollectionReference orgCollection = firestore.collection('organizations');
      await orgCollection.add({
        'id' : generateID(),
        'text' : 'Default',
        'children' :[],
        'level' : 0,
        'owner' : newDocumentRef.id,
        'depth' : 3
      });

      CollectionReference tenantsCollection = firestore.collection('tenants');

      Tenant new_user = Tenant(
        name : username,
        email: email,
        password: password,
        active: false,
        address : '',
        phone:mobile,
        landline: landline,
        office: '',
        fax : '',
        renewal_date: DateTime(2023,1,1),
        created_date: DateTime.now(),
        logo : '',
        user_id: newDocumentRef.id,
      );
      new_user.country = countryID!;
      new_user.firstname = firstname!;
      new_user.lastname = lastname!;
      new_user.hasOffice = hasOffice;

      await tenantsCollection.add(new_user.toJson());
      return true;
    } catch (e) {
      print(e);
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

}
