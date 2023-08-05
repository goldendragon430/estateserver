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
      await usersCollection.add({
        'email' : email,
        'landline' : landline,
        'role' : 1,
        'state' : true,
        'username' : username
      });
      return true;
    } catch (e) {
      throw Exception('$e');
    }
    return false;
  }


}
