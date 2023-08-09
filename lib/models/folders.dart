import 'groups.dart';
class Folder {
    String? id;
    String? name;
    bool? active;
    bool? unlimited_group;
    List<Group>? groups;
    DateTime? created_date;
  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> group_data = [];

    for (Group group in groups!){
      group_data.add(group.toJson());
    }
    return {
      'id' : id,
      'name' : name,
      'active' : active,
      'unlimited_group' : unlimited_group,
      'groups': group_data,
      'created_date' : created_date.toString()
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    name = data?['name'];
    active = data?['active'];
    if(data?['created_date'] != null){
      created_date = DateTime.parse(data?['created_date']) ;
    }else{
      created_date = DateTime(2023,1,1);
    }
    unlimited_group = data?['unlimited_group'];
    List<dynamic> group_data = data?['groups'];
    List<Group> groupData = [];
    for(dynamic group in group_data){
      Group newGroup = Group();
      newGroup.fromJson(group);
      groupData.add(newGroup);
    }
    groups = groupData;
  }
  Folder({
      this.id,
      this.name,
      this.active,
      this.unlimited_group,
      this.groups,
      this.created_date
  });
}