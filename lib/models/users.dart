class User {
   String? subuser_id;
   String? email;
   String? username;
   String? landline;
   String? parent_user;
   int role;
   bool state;
   Map<String,dynamic> toJson(){
     return {
       'subuser_id' : subuser_id,
       'username' : username,
       'email' : email,
       'landline' : landline,
       'parent_user' : parent_user,
       'role' : role,
       'state' : state
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

   }
  User({
    this.subuser_id = '',
    this.email = '',
    this.username = '',
    this.landline = '',
    this.role = 2,
    this.state = true,
    this.parent_user = ''
  });
}