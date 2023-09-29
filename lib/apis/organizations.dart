import 'package:cloud_firestore/cloud_firestore.dart';
class OrganizationService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> createOrganization(String title, String id, String owner) async{
    try{
      CollectionReference organizationsCollection = firestore.collection('organizations');
      await organizationsCollection.add({
        'id' : id,
        'text' : title,
        'children' :[],
        'level' : 0,
        'owner' : owner,
        'depth' : 3
      });
      return true;
    }catch(e){
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> getOrganizations(String id) async{
    try {
      CollectionReference organizationsCollection = firestore.collection('organizations');
      QuerySnapshot querySnapshot = await organizationsCollection.where('owner', isEqualTo: id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Map<String, dynamic>> result = [];
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        result.add(data!);
      }
      return result;
    } catch (e) {
      print('$e');
      return [];
    }

  }
  Future<bool> saveChanges(List<Map<String,dynamic>> data, String id) async{
    try {
      CollectionReference organizationsCollection = firestore.collection('organizations');
      QuerySnapshot querySnapshot = await organizationsCollection.where('owner',isEqualTo: id).get();
      if(querySnapshot.docs.length > 0){
        for(QueryDocumentSnapshot doc in querySnapshot.docs) {
         await doc.reference.delete();
        }
      }
      for( int i = 0 ; i < data.length; i ++){
        await organizationsCollection.add(data[i]);
      }
      return true;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }
  }


}
