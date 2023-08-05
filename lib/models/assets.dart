

import 'package:assetmamanger/models/inspections.dart';

class Asset {
  String? id;
  String? name;
  DateTime? acquired_date;
  DateTime? last_inspection_date;
  String? comment;
  List<String>? images;
  List<Inspection>? inspections;
  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> image_data = [];
    for (String image in images!){
      image_data.add({'path' : image});
    }
    List<Map<String,dynamic>> inspect_data = [];

    for (Inspection ins in inspections!){
      inspect_data.add(ins.toJson());
    }

    return {
      'id' : id,
      'name' : name,
      'acquired_date' : acquired_date.toString(),
      'last_inspection_date' : last_inspection_date.toString(),
      'comment' : comment.toString(),
      'images' : image_data,
      'inspections' : inspect_data
    };
  }
  void fromJson(Map<String,dynamic>? data){
    id = data?['id'];
    name = data?['name'];
    acquired_date = DateTime.parse(data?['acquired_date']);
    last_inspection_date = DateTime.parse(data?['last_inspection_date']);
    comment = data?['comment'];


    List<dynamic> image_data = data?['images'];
    List<String> imageData = [];
    for(dynamic img in image_data){
      Map<String,String> dd = img;
      imageData.add(dd['path']!);
    }
    images = imageData;

    List<dynamic> inspection_data = data?['inspections'];
    List<Inspection> inspectionData = [];
    for(dynamic ins in inspection_data){
      Inspection newIns = Inspection();
      newIns.fromJson(ins);
      inspectionData.add(newIns);
    }
    inspections = inspectionData;
  }

  Asset({
    this.id,
    this.name,
    this.acquired_date,
    this.last_inspection_date,
    this.comment,
    this.images,
    this.inspections
  });
}