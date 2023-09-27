import 'package:assetmamanger/models/assets.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assetmamanger/models/tenants.dart';
class AssetService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<bool> changeAsset(Asset asset) async{
    try {
      CollectionReference assetsCollection = firestore.collection('assets');
      QuerySnapshot querySnapshot = await assetsCollection.where('id', isEqualTo: asset.id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length > 0){
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        DocumentReference documentReference = document.reference;
        await documentReference.update(
            asset.toJson()
        );
      }
      else{
         await assetsCollection.add(asset.toJson());
      }
    } catch (e) {
      print('$e');
    }
    return true;

  }
  Future<bool> deleteAsset(Asset asset) async{
    try {
      CollectionReference assetsCollection = firestore.collection('assets');
      QuerySnapshot querySnapshot = await assetsCollection.where('id', isEqualTo: asset.id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      if(documents.length > 0){
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        DocumentReference documentReference = document.reference;
        await documentReference.delete();
      }
    } catch (e) {
      print('$e');
      return false;
    }
    return true;
  }
  Future<List<Asset>> getAssets(String tenant_id, String node_id, String asset_type_id) async{
    List<Asset> result = [];
    try {
      CollectionReference assetsCollection = firestore.collection('assets');
      QuerySnapshot querySnapshot;
      if(asset_type_id == '0')
        querySnapshot = await assetsCollection.where('node_id', isEqualTo: node_id).where('owner_id', isEqualTo: tenant_id).get();
      else
        querySnapshot = await assetsCollection.where('node_id', isEqualTo: node_id).where('owner_id', isEqualTo: tenant_id).where('asset_type_id', isEqualTo: asset_type_id).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        Asset temp = Asset();
        temp.fromJson(data);
        result.add(temp);
      }
    } catch (e) {
      print('$e');
    }
    return result;
  }
  Future<bool> checkNode(String id) async{
    try {
      CollectionReference subUserCollection = firestore.collection('assets');
      QuerySnapshot querySnapshot = await subUserCollection.get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for(DocumentSnapshot document in documents){
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if((data!['node_id'] as String).contains(id)) return true;
      }

      return false;
    } catch (e) {
      print('$e');
      return false;
      throw Exception('$e');
    }

  }
}
