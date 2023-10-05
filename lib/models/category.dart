import 'assets.dart';

class Category {
   String? id;
   String? name;
   String? userid;
  Map<String,dynamic> toJson(){

    return {
      'id' : id,
      'name' : name,
      'userid' : userid
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    name = data?['name'];
    userid = data?['userid'];
  }

  Category({
    this.id,
    this.name,
    this.userid
  });
}