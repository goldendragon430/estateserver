import 'folders.dart';
class Tenant {
   // String? id ;
   String? name  = '';
   String? email = '';
   String? address = '' ;
   String? phone = '' ;
   String? fax = '' ;
   String? landline = '' ;
   String? office = '' ;
   DateTime? renewal_date = DateTime(2023,1,1) ;
   bool? active  = false;
   bool? unlimited_folder = false ;
   bool? unlimited_group = false ;
   List<Folder>? folders = [] ;
   String? user_id = '' ;
   String? logo = '' ;
   DateTime? created_date = DateTime(2023,1,1) ;

   Map<String,dynamic> toJson(){
     List<Map<String,dynamic>> folder_data = [];
     for (Folder folder in folders!){
       folder_data.add(folder.toJson());
     }


     return {
       // 'id' : id,
       'name' : name,
       'email' : email,
       'address' : address,
       'phone' : phone,
       'fax' : fax,
       'landline' : landline,
       'office' : office,
       'renewal_date' : renewal_date.toString(),
       'created_date' : created_date.toString(),
       'active' : active,
       'unlimited_folder' : unlimited_folder,
       'unlimited_group' : unlimited_group,
       'user_id' : user_id,
       'logo' : logo,
       'folders': folder_data
     };
   }

   void fromJson(Map<String,dynamic>? data) {
     // id = data?['id'];
     name = data?['name'];
     email = data?['email'];
     address = data?['address'];
     phone = data?['phone'];
     fax = data?['fax'];
     landline = data?['landline'];
     office = data?['office'];
     renewal_date = DateTime.parse(data?['renewal_date']) ;
     if(data?['created_date'] != null)
        created_date = DateTime.parse(data?['created_date']);
     else
       created_date = DateTime(2023,1,1);
     active = data?['active'];
     unlimited_folder = data?['unlimited_folder'];
     unlimited_group = data?['unlimited_group'];
     user_id = data?['user_id'];
     logo = data?['logo'];
     List<dynamic> folder_data = data?['folders'];
     List<Folder> folderData = [];
     for(dynamic folder  in folder_data){
       Folder newFolder = Folder();
       newFolder.fromJson(folder);
       folderData.add(newFolder);
     }
     folders = folderData;
   }
  Tenant({
     // this.id,
     this.name,
     this.email,
     this.active,
     this.unlimited_folder,
     this.unlimited_group,
     this.address,
     this.phone,
     this.fax,
     this.landline,
     this.office,
     this.renewal_date,
     this.folders,
     this.user_id,
     this.logo,
     this.created_date
  });

}