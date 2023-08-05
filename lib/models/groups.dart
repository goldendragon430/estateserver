import 'assetTypes.dart';
class Group {
   String? id;
   String? name;
   bool? active;
   List<AssetType>? assetTypes;


   Map<String,dynamic> toJson(){
     List<Map<String,dynamic>> type_data = [];
     for (AssetType atype in assetTypes!){
       type_data.add(atype.toJson());
     }
     return {
       'id' : id,
       'name' : name,
       'active' : active,
       'assetTypes': type_data
     };
   }

   void fromJson(Map<String,dynamic>? data) {
     id = data?['id'];
     name = data?['name'];
     active = data?['active'];
     List<dynamic> asset_type_data = data?['assetTypes'];
     List<AssetType> assetTypeData = [];
     for(dynamic atype in asset_type_data){
       AssetType newAssetType = AssetType();
       newAssetType.fromJson(atype);
       assetTypeData.add(newAssetType);
     }
     assetTypes = assetTypeData;
   }

  Group({
     this.id,
     this.name,
     this.active,
     this.assetTypes
  });
}