

import 'package:assetmamanger/models/inspections.dart';

class Asset {
  String? id;
  String? name;
  DateTime? acquired_date;
  DateTime? last_inspection_date;
  DateTime? created_date;
  String? comment;
  List<Inspection>? inspections;
  Map<String,dynamic> toJson(){
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
      'inspections' : inspect_data,
      'created_date' : created_date == null ? DateTime(2023,1,1).toString() : created_date.toString()
    };
  }
  void fromJson(Map<String,dynamic>? data){
    id = data?['id'];
    name = data?['name'];
    acquired_date = DateTime.parse(data?['acquired_date']);
    last_inspection_date = DateTime.parse(data?['last_inspection_date']);
    comment = data?['comment'];

    if(data?['created_date'] != null && data?['created_date'] != 'null'){
      created_date = DateTime.parse(data?['created_date']);
    }else{
      created_date  = DateTime(2023,1,1);
    }
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
    this.inspections,
    this.created_date
  });
}