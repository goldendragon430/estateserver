class User {
   String? subuser_id;
   String? email;
   String? username;
   String? landline;
   String? parent_user;
   int role;
   bool state;
   int acess_level;
   String? acess_id;
   Map<String,dynamic> toJson(){
     return {
       'subuser_id' : subuser_id,
       'username' : username,
       'email' : email,
       'landline' : landline,
       'parent_user' : parent_user,
       'role' : role,
       'state' : state,
       'access_level' : acess_level,
       'access_id'    : acess_id
     };
   }
   void fromJson(Map<String,dynamic>? data){
     subuser_id = data?['subuser_id'];
     username = data?['username'];
     email = data?['email'];
     landline = data?['landline'];
     parent_user = data?['parent_user'];
     role = data?['role'];
     state = data?['state'];
     if(data?['access_level'] == null) {
       acess_level = 0;
     }
     else{
       acess_level = data?['access_level'];
     }
     if(data?['access_id'] == null) {
       acess_id = '';
     }
     else{
       acess_id = data?['access_id'];
     }

   }
  User({
    this.subuser_id = '',
    this.email = '',
    this.username = '',
    this.landline = '',
    this.role = 2,
    this.state = true,
    this.parent_user = '',
    this.acess_id = '',
    this.acess_level = 0
  });
}