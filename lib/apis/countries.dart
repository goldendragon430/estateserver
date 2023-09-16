import 'package:cloud_firestore/cloud_firestore.dart';
class CountryService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveChanges(List<Map<String,dynamic>> data) async{
    try {
      CollectionReference countriesCollection = firestore.collection('countries');
      QuerySnapshot querySnapshot = await countriesCollection.get();

      for (var document in querySnapshot.docs) {
        document.reference.delete();
      }
      for (Map row in data){
        print(row);
        await countriesCollection.add(row);
      }
      return true;

    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
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
}
