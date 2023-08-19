

class Inspection {
    String? id;
    DateTime? inspection_date;
    bool? full_condition;
    String? asset_money_value;
    DateTime? next_inspect_date;
    String? comment;
    String? logo;
    String? status;
    String? value;
    Map<String,dynamic> toJson(){
      return {
        'id' : id,
        'inspection_date' : inspection_date.toString(),
        'full_condition' : full_condition,
        'asset_money_value' : asset_money_value,
        'next_inspect_date' : next_inspect_date.toString(),
        'comment' : comment,
        'logo' : logo,
        'status' : status,
        'value' : value
      };
    }
    void fromJson(Map<String,dynamic>? data){
      id = data?['id'];
      inspection_date = DateTime.parse(data?['inspection_date']);
      full_condition = data?['full_condition'];
      asset_money_value = data?['asset_money_value'];
      comment = data?['comment'];
      logo = data?['logo'];
      next_inspect_date = DateTime.parse(data?['next_inspect_date']);
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
    }

  Inspection({
      this.id,
      this.inspection_date,
      this.full_condition,
      this.asset_money_value,
      this.next_inspect_date,
      this.comment,
      this.logo,
      this.status,
      this.value
  });
}