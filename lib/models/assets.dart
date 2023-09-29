

import 'package:assetmamanger/models/Image.dart';
import 'package:assetmamanger/models/inspections.dart';

class Asset {
  String? id;
  String? code;
  String? name;
  String? description;
  String? address;
  String? contact;
  String? phone;
  DateTime? acquired_date;
  String? acquired_value;
  String? cost_center;
  String? asset_type_id;
  String? category_id;
  String? node_id;
  String? status;
  DateTime? registered_date;
  String? registered_by;
  String? comment;
  String? owner_id;
  String? org_id;
  List<Inspection>? inspections;
  List<CustomImage>? images = [];

  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> inspect_data = [];
    for (Inspection ins in inspections!){
      inspect_data.add(ins.toJson());
    }

    return {
      'id' : id,
      'code' : code,
      'name' : name,
      'description' : description,
      'address' : address,
      'contact' : contact,
      'phone' : phone,
      'acquired_date' : acquired_date.toString(),
      'acquired_value' : acquired_value,
      'cost_center' : cost_center,
      'asset_type_id' : asset_type_id,
      'category_id' : category_id,
      'status' : status,
      'comment' : comment,
      'registered_by' : registered_by,
      'registered_date' : registered_date == null ? DateTime(2023,1,1).toString() : registered_date.toString(),
      'inspections' : inspect_data,
      'images' : images == null ? [] : List.from(images!.map((x) => x.toJson())),
      'node_id' : node_id,
      'owner_id' : owner_id,
      'org_id' : org_id
    };
  }
  void fromJson(Map<String,dynamic>? data){
    id = data?['id'];
    code = data?['code'];
    name = data?['name'];
    description = data?['description'];
    address = data?['address'];
    contact = data?['contact'];
    phone = data?['phone'];
    acquired_date = DateTime.parse(data?['acquired_date']);
    acquired_value = data?['acquired_value'];
    cost_center = data?['cost_center'];
    asset_type_id = data?['asset_type_id'];
    category_id = data?['category_id'];
    comment = data?['comment'];
    status = data?['status'];
    registered_date = DateTime.parse(data?['registered_date']);
    registered_by = data?['registered_by'];
    node_id = data?['node_id'];
    owner_id = data?['owner_id'];
    org_id = data?['org_id'];

    List<dynamic> inspection_data = data?['inspections'];
    List<Inspection> inspectionData = [];
    for(dynamic ins in inspection_data){
      Inspection newIns = Inspection();
      newIns.fromJson(ins);
      inspectionData.add(newIns);
    }
    inspections = inspectionData;

    List<dynamic> m_images = data?['images'];
    List<CustomImage> imagesData = [];
    for(dynamic ins in m_images){
      CustomImage newIns = CustomImage();
      newIns.fromJson(ins);
      imagesData.add(newIns);
    }
    images = imagesData;
  }

  Asset({
    this.id,
    this.code,
    this.name,
    this.description,
    this.address,
    this.contact,
    this.phone,
    this.acquired_date,
    this.acquired_value,
    this.cost_center,
    this.asset_type_id,
    this.category_id,
    this.status,
    this.comment,
    this.registered_by,
    this.registered_date,
    this.inspections,
    this.images,
    this.node_id,
    this.owner_id,
    this.org_id
  });
}