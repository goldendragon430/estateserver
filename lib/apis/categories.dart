import 'package:assetmamanger/models/assetTypes.dart';
import 'package:assetmamanger/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CategoryService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveChanges(List<Category> data, String id) async{
    try {
      CollectionReference categoryCollection = firestore.collection('categories');
      QuerySnapshot querySnapshot = await categoryCollection.where('userid',isEqualTo: id).get();

      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
      for (Category row in data){
        await categoryCollection.add(row.toJson());
      }
      return true;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }

  }

  Future<List<Category>> getCategory(String id) async{
    try {
      CollectionReference categoryCollection = firestore.collection('categories');
      QuerySnapshot querySnapshot = await categoryCollection.where('userid',isEqualTo: id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Category> result = [];
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        Category dd = new Category();
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
