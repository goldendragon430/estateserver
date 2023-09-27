import 'package:cloud_firestore/cloud_firestore.dart';
class CountryService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveChanges(Map<String,dynamic> data) async{
    try {
      CollectionReference countriesCollection = firestore.collection('countries');
      QuerySnapshot querySnapshot = await countriesCollection.where('id', isEqualTo: data['id']).get();
      if(querySnapshot.docs.length > 0){
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        DocumentReference documentReference = document.reference;
        await documentReference.update(
            data
        );
      }
      return true;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }
  }
  Future<bool> createCountry(String title, String id) async{
    try{
      CollectionReference tenantsCollection = firestore.collection('countries');
      await tenantsCollection.add({
        'id' : id,
        'text' : title,
        'children' :[],
        'level' : 0
      });
      return true;
    }catch(e){
    return false;
    }
  }
  Future<bool> deleteCountry(String id) async{
    try{
      CollectionReference countriesCollection = firestore.collection('countries');
      QuerySnapshot querySnapshot = await countriesCollection.where('id', isEqualTo: id).get();
      if(querySnapshot.docs.length > 0){
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        DocumentReference documentReference = document.reference;
        await documentReference.delete();
      }
      return true;
    }catch(e){
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> getCountries() async{
    try {
      CollectionReference tenantsCollection = firestore.collection('countries');
      QuerySnapshot querySnapshot = await tenantsCollection.get();
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
  Future<Map<String, dynamic>?> getCountry(String id) async{
    try {
      CollectionReference tenantsCollection = firestore.collection('countries');
      QuerySnapshot querySnapshot = await tenantsCollection.where('id',isEqualTo: id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;

      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        return data!;
      }
      return null;
    } catch (e) {
      print('$e');
      return null;
    }

  }

}
