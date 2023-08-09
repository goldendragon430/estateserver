import 'category.dart';
class AssetType {
   String? id;
   String? type;
   List<Category>? categories ;

  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> category_data = [];


    for (Category category in categories!){
      category_data.add(category.toJson());
    }
    return {
      'id' : id,
      'type' : type,
      'categories': category_data
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    type = data?['type'];
    List<dynamic> category_data = data?['categories'];
    List<Category> categoryData = [];
    for(dynamic category in category_data){
      Category newCategory = Category();
      newCategory.fromJson(category);
      categoryData.add(newCategory);
    }
    categories = categoryData;
  }
  AssetType({
    this.id,
    this.type,
    this.categories
  });
}