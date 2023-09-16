import 'assets.dart';

class Category {
   String? id;
   String? name;

  Map<String,dynamic> toJson(){

    return {
      'id' : id,
      'name' : name,

    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    name = data?['name'];

  }

  Category({
    this.id,
    this.name,

  });
}