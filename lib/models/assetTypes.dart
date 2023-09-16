import 'category.dart';
class AssetType {
   String? id;
   String? type;

  Map<String,dynamic> toJson(){
     return {
      'id' : id,
      'type' : type
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    type = data?['type'];
  }
  AssetType({
    this.id,
    this.type
  });
}