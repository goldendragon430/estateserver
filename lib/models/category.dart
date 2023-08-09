import 'assets.dart';

class Category {
   String? id;
   String? name;
   List<Asset>? assets;

  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> asset_data = [];

    for (Asset asset in assets!){
      asset_data.add(asset.toJson());
    }
    return {
      'id' : id,
      'name' : name,
      'assets': asset_data
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    name = data?['name'];
    List<dynamic> asset_data = data?['assets'];
    List<Asset> assetData = [];
    for(dynamic asset in asset_data){
      Asset newAsset = Asset();
      newAsset.fromJson(asset);
      assetData.add(newAsset);
    }
    assets = assetData;
  }

  Category({
    this.id,
    this.name,
    this.assets
  });
}