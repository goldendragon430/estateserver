



import 'package:assetmamanger/models/Image.dart';

class Inspection {
    String? id;
    DateTime? inspection_date;
    String? inspection_by;
    String? comment;
    String? status;
    String? value;
    DateTime? next_inspect_date;
    List<Image>? images = [];

    Map<String,dynamic> toJson(){
      return {
        'id' : id,
        'inspection_date' : inspection_date.toString(),
        'inspection_by':inspection_by,
        'comment' : comment,
        'status' : status,
        'value' : value,
        'next_inspect_date' : next_inspect_date.toString(),
        'images' : images == null ? [] : List.from(images!.map((x) => x.toJson())),
      };
    }
    void fromJson(Map<String,dynamic>? data){
      id = data?['id'];
      inspection_date = DateTime.parse(data?['inspection_date']);
      inspection_by = data?['inspection_by'];
      comment = data?['comment'];
      if(data?['status'] == null) {
        status = 'Active';
      }
      else
        status = data?['status'];
      if(data?['value'] == null)
        {
          value = '0';
        }
      else
        value = data?['value'];
      next_inspect_date = DateTime.parse(data?['next_inspect_date']);

      List<dynamic> m_images = data?['images'];
      List<Image> imagesData = [];
      for(dynamic ins in m_images){
        Image newIns = Image();
        newIns.fromJson(ins);
        imagesData.add(newIns);
      }
      images = imagesData;
    }

  Inspection({
      this.id,
      this.inspection_date,
      this.inspection_by,
      this.comment,
      this.status,
      this.value,
      this.next_inspect_date,
      this.images
   });
}