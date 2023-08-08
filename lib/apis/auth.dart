import 'package:assetmamanger/models/tenants.dart';
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
      throw Exception('$e');
    }
    return false;
  }


}
