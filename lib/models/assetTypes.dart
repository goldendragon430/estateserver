import 'category.dart';
class AssetType {
   String? id;
   String? type;
   String? userid;

  Map<String,dynamic> toJson(){
     return {
       'id' : id,
       'type' : type,
       'userid' : userid
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    type = data?['type'];
    userid = data?['userid'];
  }
  AssetType({
    this.id,
    this.type,
    this.userid
  });
}