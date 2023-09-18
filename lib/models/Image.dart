

class CustomImage {
  String? id;
  String? url;
  String? description;


  Map<String,dynamic> toJson(){
    return {
      'id' : id,
      'url' : url,
      'description':description,

    };
  }
  void fromJson(Map<String,dynamic>? data){
    id = data?['id'];
    url =  data?['url'];
    description = data?['description'];

  }

  CustomImage({
    this.id,
    this.url,
    this.description,

  });
}