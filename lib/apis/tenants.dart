import 'package:assetmamanger/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assetmamanger/models/tenants.dart';
class TenantService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Tenant?> getTenantDetails(String userId) async{
    try {
      CollectionReference tenantsCollection = firestore.collection('tenants');
      QuerySnapshot querySnapshot = await tenantsCollection.where('user_id', isEqualTo: userId).get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length == 0)
          return null;
      Map<String, dynamic>? data = documents[0].data() as Map<String, dynamic>?;
      Tenant result = Tenant();
      result.fromJson(data);
      return result;

    } catch (e) {
      print('$e');
      return null;
     }

  }

  Future<bool> createTenantDetails(Tenant tenant) async{
    try {
      CollectionReference usersCollection = firestore.collection('tenants');
      QuerySnapshot querySnapshot = await usersCollection.where('user_id', isEqualTo: tenant.user_id).get();
      if(querySnapshot.docs.length > 0){
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        DocumentReference documentReference = document.reference;
        await documentReference.update(
          tenant.toJson()
        );
      }
      else{
        CollectionReference tenantsCollection = firestore.collection('tenants');
        await tenantsCollection.add(tenant.toJson());
      }
      return true;

    } catch (e) {
      return false;
      throw Exception('$e');
    }

  }

  Future<List<Tenant>> getAllTenant() async{
    List<Tenant> result = [];
    try {
      CollectionReference tenantsCollection = firestore.collection('tenants');
      QuerySnapshot querySnapshot = await tenantsCollection.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        Tenant temp = Tenant();
        temp.fromJson(data);
        result.add(temp);
      }
    } catch (e) {
      print('$e');
    }
    return result;
  }
}
