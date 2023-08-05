import 'groups.dart';
class Folder {
    String? id;
    String? name;
    bool? active;
    bool? unlimited_group;
    List<Group>? groups;

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
      'groups': group_data
    };
  }

  void fromJson(Map<String,dynamic>? data) {
    id = data?['id'];
    name = data?['name'];
    active = data?['active'];
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
      this.groups
  });
}