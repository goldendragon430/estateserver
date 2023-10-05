import 'package:assetmamanger/models/assetTypes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TypeService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveChanges(List<AssetType> data,String id) async{
    try {
      CollectionReference typesCollection = firestore.collection('assettypes');
      QuerySnapshot querySnapshot = await typesCollection.where('userid',isEqualTo: id).get();

      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
      for (AssetType row in data){
        await typesCollection.add(row.toJson());
      }
      return true;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }

  }

  Future<List<AssetType>> getTypes(String id) async{
    try {
      CollectionReference typesCollection = firestore.collection('assettypes');
      QuerySnapshot querySnapshot = await typesCollection.where('userid',isEqualTo: id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<AssetType> result = [];
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        AssetType type = new AssetType();
        type.fromJson(data);
        result.add(type);
      }
      return result;
    } catch (e) {
      print('$e');
      return [];
    }

  }
}
