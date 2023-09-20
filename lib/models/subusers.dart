

class SubUser {
  String id;
  String user_id;
  int role = 0; // 0- Asset Manager 1- Asset Inspector 2- Asset Data View
  String node_id = '';
  String name = '';
  String? email = '';
  String? password = '';
  Map<String,dynamic> toJson(){
    return {
      'id' : id,
      'user_id':user_id,
      'role' : role,
      'node_id' : node_id,
      'name' : name,
      'email' : email,
      'password' : password
    };
  }
  void fromJson(Map<String,dynamic>? data){
    id = data?['id'];
    user_id = data?['user_id'];
    role = data?['role'];
    node_id = data?['node_id'];
    name = data?['name'];
    email = data?['email'];
    password = data?['password'];
  }

  SubUser({
    required this.id,
    required this.user_id,
    required this.role,
    required this.node_id,
    required this.name,
    this.email,
    this.password
  });
}