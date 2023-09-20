import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:assetmamanger/models/subusers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveChanges(List<SubUser> data) async{
    try {
      CollectionReference subUserCollection = firestore.collection('subusers');
      QuerySnapshot querySnapshot = await subUserCollection.get();

      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
      for (SubUser row in data){
        await subUserCollection.add(row.toJson());
      }
      return true;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }

  }

  Future<List<SubUser>> getSubUsers() async{
    try {
      CollectionReference subUserCollection = firestore.collection('subusers');
      QuerySnapshot querySnapshot = await subUserCollection.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<SubUser> result = [];
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        SubUser dd =  SubUser(id: '', user_id: '', role: 0, node_id: '',name :'');
        dd.fromJson(data);
        result.add(dd);
      }
      return result;
    } catch (e) {
      print('$e');
      return [];
    }

  }
}
